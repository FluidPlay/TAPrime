local normalDraw = 1
local shadowDraw = 2
local reflectionDraw = 3
local refractionDraw = 4
local gameDeferredDraw = 5

local MAPSIDE_MAPINFO = "mapinfo.lua"
local mapInfo = VFS.FileExists(MAPSIDE_MAPINFO) and VFS.Include(MAPSIDE_MAPINFO) or {}
local pbrMapRaw = (mapInfo.custom or {}).pbr

-----------===================================-------------
-----------===================================-------------

local function DrawUnit(unitID, material, drawMode)
	if drawMode == normalDraw and material.customStandardUniforms then
		gl.BlendFuncSeparate(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA, GL.ZERO, GL.ZERO)
		local curShader = material.standardShader
		if not curShader then
			return end
		for _, uniformData in pairs(material.customStandardUniforms) do
			if not uniformData.location then
				uniformData.location = gl.GetUniformLocation(curShader, uniformData.name)
			end
			local valType = type(uniformData.value)
			if valType == "table" then
				gl.Uniform(uniformData.location, unpack(uniformData.value))
			elseif valType == "number" then
				gl.Uniform(uniformData.location, uniformData.value)
			else
				Spring.Echo(string.format("10_pbr.lua: Wrong shader uniform type (%s) for uniform (%s)", valType, uniformData.name))
			end
		end
		-- TODO: check if this is reqired(it should not be)
		local gf = Spring.GetGameFrame()
		gl.UniformInt(gl.GetUniformLocation(curShader, "simFrame"), gf)
	end
end

local function SunChanged(curShader)
	gl.Uniform(gl.GetUniformLocation(curShader, "shadowDensity"), gl.GetSun("shadowDensity" ,"unit"))
	gl.Uniform(gl.GetUniformLocation(curShader, "sunColor"), gl.GetSun("diffuse" ,"unit"))
end

local function adler32(str)
	local MOD_ADLER = 65521
	local a = 1
	local b = 0
	for i = 1, #str do
		a = (a + string.byte(str, i, i)) % MOD_ADLER
		b = (b + a) % MOD_ADLER
	end
	return math.bit_or(b * 65536, a);
end

local function hashFunc(str)
	return VFS.CalculateHash(str, 0) or adler32(str)
end

local function getNumberOfChannels(val)
	if not val then
		return nil
	end
	local texUnitNum = string.match(val, "%[(%d-)%]")
	if texUnitNum then
		local texChannel = string.match(val, "%.(%a+)")
		if texChannel then
			return #texChannel
		end
	end
	return nil
end

local function getBooleanValue(obj, default)
	return (obj == nil and default) or obj
end

local function tableConcat(dest, source)
    for _, data in ipairs(source) do
        table.insert(dest, data)
    end
    return dest
end

local pbrMaterialValues = {
	["flipUV"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.flipUV, true) end,
	["fastGamma"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.fastGamma, false) end,
	["pbrWorkflow"] = function(pbrModel, pbrMap) return pbrModel.pbrWorkflow or "metallic" end,
	["tbnReortho"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.tbnReortho, true) end,

	["baseColorMap.scale"] = function(pbrModel, pbrMap) return pbrModel.baseColorMap.scale or {1.0, 1.0, 1.0, 1.0} end,
	["baseColorMap.get"] = function(pbrModel, pbrMap) return pbrModel.baseColorMap.get or nil end,
	["baseColorMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.baseColorMap.gammaCorrection, true) end,

	["normalMap.scale"] = function(pbrModel, pbrMap) return pbrModel.normalMap.scale or {1.0, 1.0, 1.0} end,
	["normalMap.get"] = function(pbrModel, pbrMap) return pbrModel.normalMap.get or nil end,
	["normalMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.normalMap.gammaCorrection, false) end,
	["normalMap.hasTangents"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.normalMap.hasTangents, true) end,

	["parallaxMap.scale"] = function(pbrModel, pbrMap) return pbrModel.parallaxMap.scale or 0.01 end,
	["parallaxMap.get"] = function(pbrModel, pbrMap) return pbrModel.parallaxMap.get or nil end,
	["parallaxMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.parallaxMap.gammaCorrection, false) end,
	["parallaxMap.fast"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.parallaxMap.fast, false) end,
	["parallaxMap.invert"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.parallaxMap.invert, true) end,
	["parallaxMap.perspective"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.parallaxMap.perspective, false) end,
	["parallaxMap.limits"] = function(pbrModel, pbrMap) return pbrModel.parallaxMap.limits or nil end,


	["emissiveMap.scale"] = function(pbrModel, pbrMap)
			if pbrModel.emissiveMap.scale then
				return pbrModel.emissiveMap.scale
			end
			local emMapGet = pbrModel.emissiveMap.get
			if emMapGet then
				local nCh = getNumberOfChannels(emMapGet)
				if nCh == 1 then
					return 1.0
				elseif nCh == 3 then
					return {1.0, 1.0, 1.0}
				end
			end
			return nil
		end,
	["emissiveMap.get"] = function(pbrModel, pbrMap) return pbrModel.emissiveMap.get or nil end,
	["emissiveMap.gammaCorrection"] = function(pbrModel, pbrMap)
			if pbrModel.emissiveMap.gammaCorrection then
				return pbrModel.emissiveMap.gammaCorrection
			end
			local emMapGet = pbrModel.emissiveMap.get
			if emMapGet then
				local nCh = getNumberOfChannels(emMapGet)
				if nCh == 1 then
					return false -- multiplier workflow, no need for gamma correction
				elseif nCh == 3 then
					return true -- color workflow, needs gamma correction
				end
			end
			return nil
		end,

	["occlusionMap.scale"] = function(pbrModel, pbrMap) return pbrModel.occlusionMap.scale or 1.0 end,
	["occlusionMap.get"] = function(pbrModel, pbrMap) return pbrModel.occlusionMap.get or nil end,
	["occlusionMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.occlusionMap.gammaCorrection, false) end,

	["roughnessMap.scale"] = function(pbrModel, pbrMap) return pbrModel.roughnessMap.scale or 1.0 end,
	["roughnessMap.get"] = function(pbrModel, pbrMap) return pbrModel.roughnessMap.get or nil end,
	["roughnessMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.roughnessMap.gammaCorrection, false) end,

	["metallicMap.scale"] = function(pbrModel, pbrMap) return pbrModel.metallicMap.scale or 1.0 end,
	["metallicMap.get"] = function(pbrModel, pbrMap) return pbrModel.metallicMap.get or nil end,
	["metallicMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrModel.metallicMap.gammaCorrection, false) end,

	["iblMap.scale"] = function(pbrModel, pbrMap) return pbrMap.iblMap.scale or pbrModel.iblMap.scale or 1.0 end,
	["iblMap.get"] = function(pbrModel, pbrMap) return pbrMap.iblMap.get or pbrModel.iblMap.get or nil end,
	["iblMap.gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrMap.iblMap.gammaCorrection, getBooleanValue(pbrModel.iblMap.gammaCorrection, false)) end,
	["iblMap.lod"] = function(pbrModel, pbrMap) return pbrMap.iblMap.lod or pbrModel.iblMap.lod or nil end,
	["iblMap.invToneMapExp"] = function(pbrModel, pbrMap) return pbrMap.iblMap.invToneMapExp or pbrModel.iblMap.invToneMapExp or nil end,
	--["iblMap.customIrradianceMap"] = function(pbrModel, pbrMap) return pbrMap.iblMap.customIrradianceMap or pbrModel.iblMap.customIrradianceMap or nil end,
	--["iblMap.customSpecularMap"] = function(pbrModel, pbrMap) return pbrMap.iblMap.customSpecularMap or pbrModel.iblMap.customSpecularMap or nil end,

	["exposure"] = function(pbrModel, pbrMap) return pbrMap.exposure or pbrModel.exposure or 1.0 end,
	["toneMapping"] = function(pbrModel, pbrMap) return pbrMap.toneMapping or pbrModel.toneMapping or nil end,
	["gammaCorrection"] = function(pbrModel, pbrMap) return getBooleanValue(pbrMap.gammaCorrection, getBooleanValue(pbrModel.gammaCorrection, true)) end,

	["texUnits"] = function(pbrModel, pbrMap)
		local allTexUnits = {}
		for k, v in pairs(pbrMap.texUnits) do
			allTexUnits[k] = v
		end

		--enable model override
		for k, v in pairs(pbrModel.texUnits) do
			allTexUnits[k] = v
		end

		return allTexUnits
	end,
}

local function sanitizePbrInputs(pbrModel, pbrMap)
	pbrModel = pbrModel or {}
	pbrModel.baseColorMap = pbrModel.baseColorMap or {}
	pbrModel.normalMap = pbrModel.normalMap or {}
	pbrModel.parallaxMap = pbrModel.parallaxMap or {}
	pbrModel.emissiveMap = pbrModel.emissiveMap or {}
	pbrModel.occlusionMap = pbrModel.occlusionMap or {}
	pbrModel.roughnessMap = pbrModel.roughnessMap or {}
	pbrModel.metallicMap = pbrModel.metallicMap or {}
	pbrModel.iblMap = pbrModel.iblMap or {}
	pbrModel.texUnits = pbrModel.texUnits or {}

	pbrMap = pbrMap or {}
	pbrMap.iblMap = pbrMap.iblMap or {}
	pbrMap.texUnits = pbrMap.texUnits or {}
	return pbrModel, pbrMap
end

local pbrDebug = { -- Debug output. Will replace output color if enabled
	baseColor = false,
	worldNormals = false,
	viewNormals = false,
	tangentNormals = false,
	parallaxShift = false,
	diffuseColor = false,
	specularColor = false,
	specularAndDiffuseColor = false,
	emissionColor = false,
	teamColor = false,
	occlusion = false,
	roughness = false,
	metallic = false,
	reflectionDir = false,
	reflectionLength = false,
	specWorldReflection = false,
	specViewReflection = false,
	irradianceWorldReflection = false,
	modelSpecularColor = false,
	modelDiffuseColor = false,
	modelTotalColor = false,
	iblSpecularColor = false,
	iblDiffuseColor = false,
	iblSpecularAndDiffuseColor = false,
	totalSpecularColor = false,
	totalDiffuseColor = false,
	totalDiffuseAOColor = false,
	shadowCoeff = false,
	shadow = false,

	tmColor = false,
	ndotL = false,
	ndotV = false,

	brdfLut = false,
}

local unitMaterials = {}
local materials = {}

local function camelToUnderline(str)
	local upperIdx = string.find(str, "%u")
	local underString = string.sub(str, 1, upperIdx - 1) .. "_" .. string.sub(str, upperIdx)
	return string.upper(underString)
end

local function parseNewMatTexUnits(modelNiceName, pbrModel, pbrMap)
	local boundTexUnits = {}
	local texUnitDefs = pbrMaterialValues["texUnits"](pbrModel, pbrMap)

	for tu, fileSpec in pairs(texUnitDefs) do
		local s, e = string.find(fileSpec, ":.-:")
		local texOpt = ""
		if s and e then
			texOpt = string.sub(fileSpec, s, e)
		end
		local fileName = string.gsub(fileSpec, ":.-:", "")
		local newFilePath = "unittextures/" .. fileName
		if VFS.FileExists(newFilePath) then
			boundTexUnits[tu] = texOpt .. newFilePath --keep :{opts}:
		else
			Spring.Echo(string.format("10_pbr.lua: Failed to load PBR texture (%s) for unit (%s)", newFilePath, modelNiceName))
		end
	end

	if not boundTexUnits["SPECULARMAP"] then
		boundTexUnits["SPECULARMAP"] = "$reflection"
	end

	if not boundTexUnits["IRRADIANCEMAP"] then
		boundTexUnits["IRRADIANCEMAP"] = "$reflection"
	end

	--Spring.Utilities.TableEcho(boundTexUnits, "boundTexUnits")

	return boundTexUnits
end

local function parsePbrMatParams(modelNiceName, pbrModel, pbrMap)

	local shaderDefinitions = {
		"#version 150 compatibility",
		"#define deferred_mode 0",
	}
	local customStandardUniforms = {}

	local deferredDefinitions = {
		"#version 150 compatibility",
		"#define deferred_mode 1",
	}
	local customDefferedUniforms = {}

	for key, valFunc in pairs(pbrMaterialValues) do
		local val = valFunc(pbrModel, pbrMap)
		local valType = type(val)
		local pntIdx = string.find(key, "%.")

		local define = {}
		local uniform = {}

		if pntIdx then
			local first  = string.sub(key, 1, pntIdx - 1)
			local second = string.sub(key, pntIdx + 1)
			--Spring.Echo(key, first, second, val)
			if first == "parallaxMap" and second == "get" and val then
				local texUnitNum = string.match(val, "%[(%d-)%]")
				local texChannel = string.match(val, "%.(%a)")
				if pbrMaterialValues["parallaxMap.invert"](pbrModel, pbrMap) then
					table.insert(define, string.format("#define GET_PARALLAXMAP(coords) (1.0 - texture(tex%d, coords).%s)" , texUnitNum, texChannel))
				else
					table.insert(define, string.format("#define GET_PARALLAXMAP(coords) (texture(tex%d, coords).%s)" , texUnitNum, texChannel))
				end
			elseif first == "parallaxMap" and second == "limits" and val and valType == "table" then
				table.insert(define, "#define PARALLAXMAP_LIMITS PARALLAXMAP_LIMITS_MANUAL")
			elseif first == "parallaxMap" and second == "limits" and val and valType == "boolean" then
				table.insert(define, "#define PARALLAXMAP_LIMITS PARALLAXMAP_LIMITS_AUTO")
			else
				if second == "get" and val then
					if first == "emissiveMap" then
						local numCh = getNumberOfChannels(pbrMaterialValues["emissiveMap.get"](pbrModel, pbrMap))
						if numCh and numCh == 1 then
							table.insert(define, "#define EMISSIVEMAP_TYPE EMISSIVEMAP_TYPE_MULT")
							table.insert(define, "#define GET_" .. string.upper(first) .. " texels" .. val)
						elseif numCh and numCh > 1 then
							table.insert(define, "#define EMISSIVEMAP_TYPE EMISSIVEMAP_TYPE_VAL")
							table.insert(define, "#define GET_" .. string.upper(first) .. " texels" .. val)
						end
					elseif valType == "string" then
						table.insert(define, "#define GET_" .. string.upper(first) .. " texels" .. val)
					elseif valType == "boolean" then
						table.insert(define, "#define GET_" .. string.upper(first))
					end
				elseif second == "gammaCorrection" and val then
					table.insert(define, "#define SRGB_" .. string.upper(first))
				elseif second == "hasTangents" and val then
					table.insert(define, "#define " .. camelToUnderline(second))
				elseif second == "invToneMapExp" and valType == "number" then
					table.insert(define, "#define IBL_INVTONEMAP")
				elseif second == "lod" and val then
					if valType == "boolean" then
						table.insert(define, "#define IBL_TEX_LOD IBL_TEX_LOD_AUTO") --automatic definition of max LOD
					else
						table.insert(define, "#define IBL_TEX_LOD IBL_TEX_LOD_MANUAL") --manual definition of max LOD
					end
				elseif second == "fast" and val then
					table.insert(define, "#define " .. "PARALLAXMAP_FAST")
				elseif second == "perspective" and val then
					table.insert(define, "#define " .. "PARALLAXMAP_PERSPECTIVE")
				end
			end

			if (second == "scale" or second == "strength") and val then
				table.insert(uniform, {
					name = first .. second:gsub("^%l", string.upper),
					value = val,
					location = nil,
				})
			elseif second == "lod" and valType == "number" then
				table.insert(uniform, {
					name = first .. second:gsub("%l", string.upper),
					value = val,
					location = nil,
				})
			elseif second == "limits" and val and valType == "table" then
				table.insert(uniform, {
					name = first .. second:gsub("^%l", string.upper),
					value = val,
					location = nil,
				})
			elseif second == "invToneMapExp" and valType == "number" then
				table.insert(uniform, {
					name = first .. second:gsub("^%l", string.upper),
					value = val,
					location = nil,
				})
			end
		else
			if key == "texUnits" then
				for tu, fileSpec in pairs(val) do
					--Spring.Echo("!!!!!!", tu, fileSpec)
					local fileName = string.gsub(fileSpec, ":.-:", "")
					local newFilePath = "unittextures/" .. fileName
					if VFS.FileExists(newFilePath) then
						table.insert(define, "#define HAS_" .. tu)
					else
						Spring.Echo(string.format("10_pbr.lua: Failed to load PBR texture (%s) for unit (%s)", newFilePath, modelNiceName))
					end
				end
			elseif valType == "number" then
				table.insert(uniform, {
					name = key,
					value = val,
					location = nil,
				})
			else
				if valType == "boolean" and val then
					table.insert(define, "#define " .. camelToUnderline(key))
				elseif valType == "string" then
					table.insert(define, string.format("#define %s %s_%s", string.upper(key), string.upper(key), string.upper(val)))
				end
			end
		end
		if #define > 0 then
			shaderDefinitions = tableConcat(shaderDefinitions, define)
			deferredDefinitions = tableConcat(deferredDefinitions, define)
			--Spring.Echo(key, val, "define", define)
		end

		if #uniform > 0 then
			customStandardUniforms = tableConcat(customStandardUniforms, uniform)
			customDefferedUniforms = tableConcat(customDefferedUniforms, uniform)
			--Spring.Echo(key, val, "uniform", uniform.name, uniform.value)
		end
	end

	local debugIdx = 1
	local pbrModelDebug = pbrModel.debug or {}
	local pbrMapDebug = pbrMap.debug or {}
	local def
	for k, v in pairs(pbrDebug) do
		def = string.format("#define DEBUG_%s %d", string.upper(k), debugIdx)
		table.insert(shaderDefinitions, def)
		table.insert(deferredDefinitions, def)
		debugIdx = debugIdx + 1
	end

	for k, v in pairs(pbrDebug) do
		if v or getBooleanValue(pbrMapDebug[k], getBooleanValue(pbrModelDebug[k], false)) then
			def = string.format("#define DEBUG DEBUG_%s", string.upper(k))
			table.insert(shaderDefinitions, def)
			table.insert(deferredDefinitions, def)
			break
		end
	end

	--Spring.Echo(shaderDefinitions)

	return shaderDefinitions, deferredDefinitions, customStandardUniforms, customDefferedUniforms
end

-- Take only non-uniform parameters
local function getPbrMaterialIndex(modelNiceName, pbrModel, pbrMap)
	local shaderDefinitions, deferredDefinitions = parsePbrMatParams(modelNiceName, pbrModel, pbrMap)

	local propString = ""
	propString = propString .. "\nshaderDefinitions:\n"
	propString = propString .. table.concat(shaderDefinitions, "\n")
	propString = propString .. "\ndeferredDefinitions:\n"
	propString = propString .. table.concat(deferredDefinitions, "\n")

	local hashValue = hashFunc(propString)

	--Spring.Echo(propString, hashValue)

	return hashValue
end

local function createNewMatDef(modelNiceName, pbrModel, pbrMap)
	local shaderDefinitions, deferredDefinitions, customStandardUniforms, customDefferedUniforms = parsePbrMatParams(modelNiceName, pbrModel, pbrMap)
	--Spring.Utilities.TableEcho(shaderDefinitions, "shaderDefinitions")
	--Spring.Utilities.TableEcho(customStandardUniforms, "customStandardUniforms")

	local newMat = {
		shaderDefinitions = shaderDefinitions,
		--deferredDefinitions = deferredDefinitions,
		shader    = include("ModelMaterials/Shaders/pbr.lua"),
		usecamera = false,
		culling   = GL.BACK,
		predl  = nil,
		postdl = nil,
		force = true,
		texunits = {
			[0] = "%TEX0",
			[1] = "%TEX1",
			[2] = "%TEX2",
			[3] = "%TEX3",
			--[4] = "%TEX4",
			[5] = GG.GetBrdfTexture() or "unittextures/brdflutTex.png",
			--[5] = "unittextures/brdflutTex.png",
			[6] = "$shadow",
			[7] = "%IRRADIANCEMAP", --TODO replace with radiance map!!!
			[8] = "%SPECULARMAP",
		},
		DrawUnit = DrawUnit,
		SunChanged = SunChanged,
		--UnitCreated = UnitCreated,
		--UnitDestroyed = UnitDestroyed,

		customStandardUniforms = customStandardUniforms,
		customDefferedUniforms = customDefferedUniforms,
	}
	--Spring.Utilities.TableEcho(newMat, "")

	return newMat
end

for i = 1, #UnitDefs do
	local udef = UnitDefs[i]
	local modelNiceName = string.format("%s(%s)", udef.humanName, udef.name)
	local modelFilename = string.format("Objects3d/%s.lua", udef.modelname)
	if VFS.FileExists(modelFilename) then
		local model = VFS.Include(modelFilename)
		if model and model.pbr then
			local pbrModel, pbrMap = sanitizePbrInputs(model.pbr, pbrMapRaw)
			local pbrIndex = getPbrMaterialIndex(modelNiceName, pbrModel, pbrMap)
			local pbrMatName = "pbr_" .. tostring(pbrIndex)
			if not materials[pbrMatName] then
				local pbrMatDef = createNewMatDef(modelNiceName, pbrModel, pbrMap)
				materials[pbrMatName] = pbrMatDef
			end
			local boundTexUnits = parseNewMatTexUnits(modelNiceName, pbrModel, pbrMap)
			local matDef = {pbrMatName}
			for tkey, tval in pairs(boundTexUnits) do
				matDef[tkey] = tval
			end
			unitMaterials[i] = matDef
		end
	else
		--Spring.Echo(string.format("10_pbr.lua: Failed to load model definition file (%s) for unit (%s)", modelFilename, modelNiceName))
	end
end

return materials, unitMaterials