model = {
	radius = 60.0, --25.0,
	height = 40.0,
	tex1 = "armfactories_dfs_team.dds",
	tex2 = "armfactories_emis_spec_gloss.dds",
	--tex2 = "armtech_tex2.dds",
	midpos = {0, 0, 0},
	--rotAxisSigns = {-1, -1, -1}

    --pbr = {
    --    flipUV = false, --true,      --flip second component of UV map. False is for DDS, True is for everything else. For now keep everything either in DDS or in PNG/TGA
    --    fastGamma = true,   --default is false i.e. more precise method
    --    --fastDiffuse = true, --Lambert(true) or Burley(false)
    --    tbnReortho = false,  -- Re-orthogonalize TBN matrix using Gram-Schmidt process. Might behave differently depending on "hasTangents". Default is true.
    --    pbrWorkflow = "metallic", -- either "metallic" or "specular". "specular" is not yet implemented
    --    -- PBR shader will sample a certain number of supplied textures.
    --    -- provide a recipe to map samples to PBR inputs
    --    baseColorMap = {
    --        scale = {1.0, 1.0, 1.0, 1.0}, -- acts as a color if tex unit is unused or as a multiplier if tex unit is present. Defaults to vec4(1.0).
    --        get = "[0].rgba", -- take sample from first texture unit in array.
    --        gammaCorrection = true, -- Artists see colors in sRGB, but we need colors in linear space. Therefore this defaults to true.
    --    },
    --    normalMap = {
    --        hasTangents = true, --you somehow must know if the import of the model puts tangents and bitangents to gl_MultiTexCoord[5,6]
    --        scale = {1.0, 1.0, 1.0}, -- scale for normals sampled from normalMapTex. Defaults to vec3(1.0)
    --        get = "[2].rgb", --If you use DDS and see some weird moar/acne like artifacts, use uncompressed DDS instead.
    --        gammaCorrection = false, -- Defaults to false. Don't change unless you know what you are doing!
    --    },
    --    parallaxMap = { -- parallax occlusion mapping. Will be ignored if normalMap.hasTangents == false
    --        invert = false, -- invert height value, i.e. height = (1.0 - height). Algorithm expects depth map: 0.0 to be baseline, and 1.0 to be deep (not high!!!). Default is true as many will put heightmap here anyway.
    --        fast = false, --always test if fast is good enough and only switch to "precise" if quality is bad. fast=true is simple parallax, fast=false is parallax occlusion mapping
    --        perspective = true, --whether to divide tangentViewDir.xy by tangentViewDir.z or not. A matter of personal preference. Check both.
    --        limits = true, -- Can be boolean or vec2() table. This limits how large texture coordinates offsets parallax mapping can do. Offsets bigget than limits will be clamped.
    --        scale = 0.01, --if you set this up and your model texturing (and everything else) looks off, try to divide scale by 10 and then find out the best value iteratively
    --        --get = "[1].a", -- expects linear bump map as input
    --        --get = nil,
    --        gammaCorrection = false, -- Defaults to false. Don't change unless you know what you are doing!
    --    },
    --    emissiveMap = {
    --        --scale = {1.0, 1.0, 1.0}, -- acts as a color if tex unit is unused or as a multiplier if tex unit is present. Can be a single channel, in that case it acts as a multipier to baseColor Defaults to vec3(1.0).
    --        scale = 1.5, --2.5,
    --        --get = "[2].rgb", --get can be RGB
    --        get = "[1].r", --or get can be single channel.
    --        gammaCorrection = false, -- Defaults to true, because you might provide RGB channels (see baseColorMap.gammaCorrection). If 1 channel emissive is used don't do gammaCorrection.
    --    },
    --    occlusionMap = {
    --        strength = 1.0, --multiplier in case occlusionMap is present. Does NOT act as a texture stand-in
    --        get = "[3].r",
    --        gammaCorrection = false, -- Defaults to false. Don't change unless you know what you are doing!
    --    },
    --    roughnessMap = {
    --        scale = 1.2, --acts as a multiplier or a base value (if get is nil)
    --        get = "[1].b",
    --        gammaCorrection = false, -- Defaults to false. Don't change unless you know what you are doing!
    --    },
    --    metallicMap = {
    --        scale = 1.0, --1.0; acts as a multiplier or a base value (if get is nil)
    --        get = "[1].g",
    --        gammaCorrection = false, -- Defaults to false. Don't change unless you know what you are doing!
    --    },
    --    iblMap = {
    --        --invToneMapExp = 1.3, --can be nil to disable poor man's SDR to HDR mapping
    --        scale = {1.0, 1.0}, --{diffuse, specular} IBL scale. Acts as a multiplier or a base value (if get is nil)
    --        get = true, -- to generate GET_IBLMAP definition
    --        lod = true, -- can be nil, a number, or true for auto
    --        gammaCorrection = true, --false, -- Artists see colors in sRGB, but we need colors in linear space. Therefore this defaults to true.
    --    },
    --    debug = {
    --        --tangentNormals = true,
    --    },
    --    exposure = 1.0,
    --    toneMapping = "", --valid values are "aces", "uncharted2", "filmic", "reinhard", "log", "romBinDaHouse", "lumaReinhard", "hejl2015", "steveM1", "steveM2".
    --    --gammaCorrection = true, -- do gamma correction (RGB-->sRGB) on the final color.
    --    texUnits = { -- substitute values
    --        ["TEX0"] = "armfactories_dfs_team.dds",
    --        ["TEX1"] = "armfactories_emis_metal_rough.dds",
    --        ["TEX2"] = "armfactories_normal.dds",
    --        --["TEX1"] = "Jeffy_NormalHeight_1k_3dc_mips.dds",
    --        --["TEX2"] = "Jeffy_Emissive512x512.dds",
    --        --["TEX3"] = "Jeffy_ORM_EMGS_1k.dds",
    --        --["SPECULARMAP"] = "whipple_creek_regional_park_01_1k.png",
    --        --["SPECULARMAP"] = "glazed_patio.png", --"studio_small_07_1k_.png",
    --        --["IRRADIANCEMAP"] = "",
    --    },
    --},
}
return model