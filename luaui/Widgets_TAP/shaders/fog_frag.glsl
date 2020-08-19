#line 10001
const float noiseScale = 1. / float(%f);
const float fogHeight = float(%f);
const float fogBottom = float(%f);
const float fogThicknessInv = 1. / (fogHeight - fogBottom);
const vec3 fogColor   = vec3(%f, %f, %f);
const float mapX = float(%f);
const float mapZ = float(%f);
const float fadeAltitude = float(%f);
const float opacity = float(%f);

const float sunPenetrationDepth = float(%f);

const float shadowOpacity = 0.3; //0.4;
const float sunDiffuseStrength = float(6.0);
const float noiseTexSizeInv = 1.0 / 256.0;
const float noiseCloudness = float(0.7) * 0.075; //0.5; // TODO: configurable

#ifdef CLAMP_TO_MAP
	const vec3 vAA = vec3(  1.,fogBottom,  1.);
	const vec3 vBB = vec3(mapX-1.,fogHeight,mapZ-1.);
#else
	const vec3 vAA = vec3(-300000.0, fogBottom, -300000.0);
	const vec3 vBB = vec3( 300000.0, fogHeight,  300000.0);
#endif

uniform sampler2D tex0;
uniform sampler2D tex1;

uniform vec3 eyePos;
uniform mat4 viewProjectionInv;
uniform vec3 offset;
uniform vec3 sundir;
uniform vec3 suncolor;
uniform float time;

#define NORM2SNORM(value) (value * 2.0 - 1.0)
#define SNORM2NORM(value) (value * 0.5 + 0.5)


//float sunSpecularColor = suncolor; //FIXME
const float sunSpecularExponent = float(100.0);

float noise(in vec3 x)
{
	vec3 p = floor(x);
	vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xz + vec2(37.0,17.0)*p.y) + f.xz;
	vec2 rg = texture2D( tex1, (uv + 0.5) * noiseTexSizeInv).yx;
	return smoothstep(0.5 - noiseCloudness, 0.5 + noiseCloudness, mix( rg.x, rg.y, f.y ));
}


struct Ray {
	vec3 Origin;
	vec3 Dir;
};

struct AABB {
	vec3 Min;
	vec3 Max;
};

bool IntersectBox(in Ray r, in AABB aabb, out float t0, out float t1)
{
	vec3 invR = 1.0 / r.Dir;
	vec3 tbot = invR * (aabb.Min - r.Origin);
	vec3 ttop = invR * (aabb.Max - r.Origin);
	vec3 tmin = min(ttop, tbot);
	vec3 tmax = max(ttop, tbot);
	vec2 t = max(tmin.xx, tmin.yz);
	t0 = max(0.,max(t.x, t.y));
	t  = min(tmax.xx, tmax.yz);
	t1 = min(t.x, t.y);
	//return (t0 <= t1) && (t1 >= 0.);
	return (abs(t0) <= t1);
}



const mat3 m = mat3( 0.00,  0.80,  0.60,
                    -0.80,  0.36, -0.48,
                    -0.60, -0.48,  0.64 ) * 2.01;


float MapClouds(in vec3 p)
{
	float factor = 1.0 - smoothstep(fadeAltitude, fogHeight, p.y);

	p += offset;
	p *= noiseScale;

	p += time * 0.07;

	float f = noise( p );
	p = m * p + time * 0.3;
	f += 0.4 * noise( 1.01 * p );
	p = m * p - time * 0.6;
	f += 0.2 * noise( 1.03 * p );

    f = mix(0.0, f, factor);

	return f;
}

vec4 RaymarchClouds(in vec3 start, in vec3 end, float op)
{
	float l = length(end - start);
	const float numsteps = 20.0;
	const float tstep = 1. / numsteps;
	float depth = min(l * fogThicknessInv, 1.5);

	float fogContrib = 0.;
	float sunContrib = 0.;
	float alpha = 0.;

	for (float t=0.0; t<=1.0; t+=tstep) {
		vec3  pos = mix(start, end, t);
		float fog = MapClouds(pos);
		fogContrib += fog;

		vec3  lightPos = sundir * sunPenetrationDepth + pos;
		float lightFog = MapClouds(lightPos);
		float sunVisibility = clamp((fog - lightFog), 0.0, 1.0 ) * sunDiffuseStrength;
		sunContrib += sunVisibility;

		float b = smoothstep(1.0, 0.7, abs((t - 0.5) * 2.0));
		alpha += b;
	}

	fogContrib *= tstep;
	sunContrib *= tstep;
	alpha      *= tstep * op * depth;

	vec3 ndir = (end - start) / l;
	float sun = pow( clamp( dot(sundir, ndir), 0.0, 1.0 ), sunSpecularExponent );
	sunContrib += sun * clamp(1. - fogContrib * alpha, 0.2, 1.) * 1.0;

	vec4 col;
	col.rgb = sunContrib * suncolor + fogColor;
	col.a   = fogContrib * alpha;
	return col;
}

vec3 GetWorldPos(in float z, in vec2 screenpos)
{
	vec4 ppos;
	#ifdef DEPTH_CLIP01
		ppos.xyz = vec3(NORM2SNORM(screenpos), z);
	#else
		ppos.xyz = NORM2SNORM(vec3(screenpos, z));
	#endif

	ppos.a = 1.;
	vec4 worldPos4 = viewProjectionInv * ppos;
	worldPos4.xyz /= worldPos4.w;

	if (z == 1.0) {
		vec3 forward = normalize(worldPos4.xyz - eyePos);
		float a = max(fogHeight - eyePos.y, eyePos.y - fogBottom) / forward.y;
		return eyePos + forward.xyz * abs(a);
	}

	return worldPos4.xyz;
}

vec4 Blend(in vec4 Src, in vec4 Dst)
{
	//alpha blending
	//vec4 Out = Src * Src.a + Dst * (1.0 - Src.a);
	//Out.a = max(Src.a, Dst.a);
	vec4 Out;

	//alpha blending - shit
	//Out = Src * Src.a + Dst * (1.0 - Src.a);

	Out.rgb = Src.rgb * Src.a + Dst.rgb * Dst.a;
	//Out.a = max(Src.a, Dst.a);
	Out.a = Src.a + Dst.a;

	return Out;
}


void main()
{
	// reconstruct worldpos from depthbuffer
	float z = texture2D(tex0, gl_TexCoord[0].st).x;
	vec3 worldPos = GetWorldPos(z, gl_TexCoord[0].st);

	gl_FragColor = vec4(0.0);

	#if 1
	{
		if (z != 1.0) {
			//vec4 sunPos = vec4(sundir * fogHeight / dot(sundir, vec3(0, 1, 0)), 1.0);
			vec3 sunPos = sundir * 50000.0;

			// clamp ray in boundary box
			Ray r;
			r.Origin = worldPos;
			r.Dir = sunPos - worldPos;
			AABB box;
			box.Min = vAA;
			box.Max = vBB;
			float t1, t2;

			// TODO: find a way to do this when eye is inside volume
			if (IntersectBox(r, box, t1, t2)) {
				t1 = clamp(t1, 0.0, 1.0);
				t2 = clamp(t2, 0.0, 1.0);
				vec3 startPos = r.Dir * t1 + r.Origin;
				vec3 endPos   = r.Dir * t2 + r.Origin;

				// finally raymarch the volume
				vec4 rmColor = RaymarchClouds(startPos, endPos, shadowOpacity);
				gl_FragColor.a = pow(1.5 * rmColor.a, 3.0);
			}
		}
	}
	#endif
	#if 0
	{
		// clamp ray in boundary box
		Ray r;
		r.Origin = eyePos;
		r.Dir = worldPos - eyePos;
		AABB box;
		box.Min = vAA;
		box.Max = vBB;
		float t1, t2;

		// TODO: find a way to do this when eye is inside volume
		if (IntersectBox(r, box, t1, t2)) {
			t1 = clamp(t1, 0.0, 1.0);
			t2 = clamp(t2, 0.0, 1.0);
			vec3 startPos = r.Dir * t1 + r.Origin;
			vec3 endPos   = r.Dir * t2 + r.Origin;

			// finally raymarch the volume
			vec4 rmColor = RaymarchClouds(startPos, endPos, opacity);
			gl_FragColor = Blend(gl_FragColor, rmColor);
			#ifndef CLAMP_TO_MAP
				// blend with distance to make endless fog have smooth horizon
				gl_FragColor.a *= smoothstep(gl_Fog.end * 10.0, gl_Fog.start, length(worldPos - eyePos));
			#endif
		}
	}
	#endif
}
