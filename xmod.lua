local lfs = lfs or require("lfs")

function lsdir(path, ext, ret)
    ret = ret or {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."\\"..file
            local a = lfs.attributes(f)
            if a and a.mode == "directory" then
                lsdir(f, ext, ret)
            else
                if ext then
                    if string.match(f, ext) then
                        table.insert(ret, f)
                    end
                else
                    table.insert(ret, f)
                end
            end
        end
    end
    return ret
end

function mkdir(path)
    local dir = string.match(path, "(.+)[/\\].-$")
    if dir and lfs.attributes(dir) == nil then
        mkdir(dir)
    end
    lfs.mkdir(dir)
end

FXNODE_TYPE_INVALID     = 0x00000000
FXNODE_TYPE_MESH        = 0x00000001
FXNODE_TYPE_SKIN        = 0x00000002
FXNODE_TYPE_HELPER      = 0x00000003
FXNODE_TYPE_BONE        = 0x00000004
FXNODE_TYPE_CAMERA      = 0x00000005

MODEL_POSITION_INFO		= 0x00000001  -- 顶点位置信息标记
MODEL_POSITION_ANI		= 0x00000002  -- 顶点位置动画信息标记
MODEL_NORMAL_INFO		= 0x00000004  -- 顶点的法向信息标记
MODEL_NORMAL_ANI		= 0x00000008  -- 顶点的法向动画信息标记
MODEL_COLOR_INFO		= 0x00000010  -- 顶点色信息标记
MODEL_COLOR_ANI			= 0x00000020  -- 顶点色动画信息标记
MODEL_ILLUM_INFO		= 0x00000040  -- 顶点流明信息标记
MODEL_ILLUM_ANI			= 0x00000080  -- 顶点流明动画信息标记
MODEL_TANGENT_INFO		= 0x00000100  -- 顶点切线信息标记
MODEL_TANGENT_ANI		= 0x00000200  -- 顶点切线动画信息标记
MODEL_BINORMAL_INFO		= 0x00000400  -- 顶点次法线信息标记
MODEL_BINORMAL_ANI		= 0x00000800  -- 顶点次法线动画信息标记
MODEL_MATRIX_INFO		= 0x00001000  -- 矩阵动画信息标记
MODEL_MATRIX_ANI		= 0x00002000  -- 矩阵动画信息标记
MODEL_SKIN_FLAG			= 0x00010000  -- 蒙皮标记
MODEL_MESH_FLAG			= 0x00020000  -- 网格标记
MODEL_DISAPPEAR_FLAG	= 0x00040000  -- 淡入淡出标记
MODEL_SCENEFOG_FLAG		= 0x00080000  -- 场景雾标记
MODEL_APPLIQUE_FLAG		= 0x00100000  -- 贴花模型标记
MODEL_BB_FLAG			= 0x00200000
MODEL_BBX_FLAG			= 0x00400000
MODEL_BBY_FLAG			= 0x00800000
MODEL_TREELEAF_FLAG		= 0x01000000
MODEL_HIDE_FLAG			= 0x02000000
MODEL_BLEND_FLAG		= 0x04000000
MODEL_BBEX_FLAG			= 0x08000000
MODEL_MAINMODEL_FLAG	= 0x10000000
MODEL_WATERCLIP_FLAG	= 0x20000000  -- 水面消除模型标记
MODEL_FLAG_EXT			= 0x80000000  -- 模型标记扩展标记

HELPER_POSITION_INFO	= MODEL_POSITION_INFO  -- 顶点位置信息标记
HELPER_POSITION_ANI		= MODEL_POSITION_ANI  -- 顶点位置动画信息标记
HELPER_NORMAL_INFO		= MODEL_NORMAL_INFO  -- 顶点的法向信息标记
HELPER_NORMAL_ANI		= MODEL_NORMAL_ANI  -- 顶点的法向动画信息标记
HELPER_MATRIX_INFO		= MODEL_MATRIX_INFO  -- 矩阵动画信息标记
HELPER_MATRIX_ANI		= MODEL_MATRIX_ANI  -- 矩阵动画信息标记
HELPER_CAMERA_FLAG		= 0x00010000  -- 辅助点为摄像机的标记
HELPER_FLAG_EXT			= 0x80000000  -- 辅助点标记扩展标记


-- 材质标记信息
MATERIAL_AMBIENT_INFO			= 0x00000001 -- 材质环境光反射信息标记
MATERIAL_AMBIENT_ANI			= 0x00000002 -- 材质环境光反射动画信息标记
MATERIAL_DIFFUSE_INFO			= 0x00000004 -- 材质漫反射信息标记
MATERIAL_DIFFUSE_ANI			= 0x00000008 -- 材质漫反射动画信息标记
MATERIAL_SPECULAR_INFO			= 0x00000010 -- 材质镜面反射信息标记
MATERIAL_SPECULAR_ANI			= 0x00000020 -- 材质镜面反射动画信息标记
MATERIAL_EMISSIVE_INFO			= 0x00000040 -- 材质辐射信息标记
MATERIAL_EMISSIVE_ANI			= 0x00000080 -- 材质辐射动画信息标记
MATERIAL_OPACITY_INFO			= 0x00000100 -- 材质透明信息标记
MATERIAL_OPACITY_ANI			= 0x00000200 -- 材质透明动画信息标记
MATERIAL_GLOSS_INFO				= 0x00000400 -- 材质Glossiness信息标记
MATERIAL_GLOSS_ANI				= 0x00000800 -- 材质Glossiness动画信息标记
MATERIAL_DIFFUSE_MAP_INFO		= 0x00001000 -- Diffuse贴图信息标记
MATERIAL_BUMP_MAP_INFO			= 0x00002000 -- Bump贴图信息标记
MATERIAL_SPECULAR_MAP_INFO		= 0x00004000 -- Specular贴图信息标记
MATERIAL_SPECULAR_LEVEL_MAP_INFO= 0x00008000 -- Specularlevel贴图信息标记
MATERIAL_GLOSSINESS_MAP_INFO	= 0x00010000 -- Glossiness贴图信息标记
MATERIAL_REFLECTION_ENV_MAP_INFO= 0x00020000 -- Reflection贴图信息标记
MATERIAL_LIGHTMAP_INFO			= 0x00040000 -- Light贴图信息标记
MATERIAL_DIFFUSE_UV_ANI			= 0x00080000 -- DIFFUSE_MAP的UV动画信息标记
MATERIAL_SELF_ILLUMINATION_INFO	= 0x00100000 -- 自发光贴图信息标记
MATERIAL_ATEST_FLAG				= 0x00200000 -- Alpha测试标记
MATERIAL_BLEND_FLAG				= 0x00400000 -- Alpha混合标记
MATERIAL_NOLIGHT_FLAG			= 0x00800000 -- 无光照标记
MATERIAL_BLENDENHANCE_FLAG		= 0x01000000 -- 高亮叠加标记
MATERIAL_REFRACTION_FLAG		= 0x02000000 -- 折射材质标记
MATERIAL_NOZWRITE_FLAG			= 0x04000000 -- 无深度写入标记
MATERIAL_DOUBLESIDE_FLAG		= 0x08000000 -- 双面材质标记
MATERIAL_BLENDQUALITY			= 0x10000000 -- 模型二次绘制标记
MATERIAL_SAMPLER_CLAMP			= 0x20000000 -- 采样过界CLAMP模式
MATERIAL_VOLUMEFOG_FLAG			= 0x40000000 -- 体积雾材质标签
MATERIAL_FLAG_EXT				= 0x80000000 -- 模型材质标记扩展标记

-- 扩展材质标记信息
MATERIAL_FRAME_INFO				=	0x00000001	-- 序列帧动画信息标记
MATERIAL_SHADOW_INFO			=	0x00000004	-- 投射阴影标记
MATERIAL_SHADOWED_INFO			=	0x00000008	-- 被投影标记
MATERIAL_BLENDSHADOW_INFO		=	0x00000010	-- 半透明阴影标记
MATERIAL_SIEVE_INFO				=	0x00000020	-- 筛孔半透明标记
MATERIAL_FILTER_MAP_INFO		=	0x00000080	-- 遮罩贴图信息标记
MATERIAL_FILTER_PARAM_ANI		=	0x00000100	-- 遮罩参数动画标记
MATERIAL_FILTER_UV_ANI			=	0x00000200	-- 遮罩贴图的UV动画信息标记




function load_xmod(fd)
    local m = {}
    m.flag = fd:read(4)
    if m.flag ~= "XVAM" then
        return nil, "_FLAG_"..tostring(m.flag)
    end
    m.version, m.fileType, m.origin = string.unpack("III", fd:read(12))
    if m.version ~= 0x1002 and m.version ~= 0x1001 and m.version ~= 0x1000 then
        --print("load xmod "..string.format("0x%08X", m.version))
        return nil, "_V_"..string.format("%X", m.version)
    end
    
    if m.origin == 0 then
        m.lodCount = string.unpack("I", fd:read(4))
    else
        m.lodCount = 1
    end
    
    m.name, m.nameLen = load_name(fd)
    m.startframe, m.endframe, m.fps = string.unpack("IIf", fd:read(12))
    
    m.rootMinX, m.rootMinY, m.rootMinZ = string.unpack("fff", fd:read(12))
    m.rootMaxX, m.rootMaxY, m.rootMaxZ = string.unpack("fff", fd:read(12))
   
    m.materialCount = 0
    m.rootNodeCount = string.unpack("I", fd:read(4))
    m.rootNodes = {}
    
    --[[
    print("[Xmod]--------------", m.name)
    for k,v in pairs(m) do
        print(k, v)
    end
    --]]
    for i = 1, m.rootNodeCount do
        m.rootNodes[i] = load_node(fd, m)
    end
    return m
end

function load_name(fd)
    local size = string.unpack("I", fd:read(4))
    if size == 0 or size > 0x100 then
        error("load name fail "..tostring(size))
    end
    local name = fd:read(size)
    return name, size
end

function load_node(fd, m)
    --print(string.format("[NODE] %X", fd:seek("cur", 0)))
    local p = {}
    p.name, p.nameLen = load_name(fd)
    p.type = string.unpack("I", fd:read(4))
    if p.type ~= FXNODE_TYPE_MESH and p.type ~= FXNODE_TYPE_SKIN and p.type ~= FXNODE_TYPE_HELPER then
        error("load node fail "..tostring(p.type))
    end
    
    p.modelInfo = load_node_info(fd, m, p)
    --location matrix
    p.location = load_location(fd, m, p)
    
    if p.type == FXNODE_TYPE_MESH or p.type == FXNODE_TYPE_SKIN then
        --split tree
        p.splitTreeOffset = string.unpack("i", fd:read(4))
        --bounding box
        if p.modelInfo & MODEL_POSITION_INFO > 0 or
            p.modelInfo & MODEL_POSITION_ANI > 0 or
            p.modelInfo & MODEL_NORMAL_INFO > 0 or
            p.modelInfo & MODEL_NORMAL_ANI > 0
        then
            p.boundMinX, p.boundMinY, p.boundMinZ = string.unpack("fff", fd:read(12))
            p.boundMaxX, p.boundMaxY, p.boundMaxZ = string.unpack("fff", fd:read(12))
        end
        
        p.materialCount = string.unpack("i", fd:read(4))
        p.materials = {}
        for i = 1, p.materialCount do
            local mat = load_material(fd, m, p)
            mat.indexInModel = m.materialCount + i
        end
        m.materialCount = m.materialCount + p.materialCount
        
        if m.version >= 0x1001 then
            p.attachedHelperCount = string.unpack("I", fd:read(4))
            p.attachedHelpers = {}
            for i = 1, p.attachedHelperCount do
                local h = load_attached(fd, m, p)
                p.attachedHelpers[i] = h
            end
        end
    end
    
    
    p.childNodeCount = string.unpack("I", fd:read(4))
    p.childNodes = {}
    
    --[[
    print("[Node]--------------", p.name)
    for k,v in pairs(p) do
        print(k, v)
    end
    --]]
    
    for i = 1, p.childNodeCount do
        local c = load_node(fd, m)
        p.childNodes[i] = c
    end
    return p
end


function load_location(fd, m, p)
    local location = nil
    local location_camera = nil
    
    if p.modelInfo & MODEL_MATRIX_ANI > 0 then
        local frame = m.endframe - m.startframe + 1
        location = {}
        for i = 1, frame do
            local t = {}
            for j = 1, 10 do
                t[j] = string.unpack("f", fd:read(4))
            end
            location[i] = t
        end

        if p.type == FXNODE_TYPE_HELPER and p.modelInfo & HELPER_CAMERA_FLAG > 0 then
            location_camera = fd:read(4*3*frame)
        end
    elseif p.modelInfo & MODEL_MATRIX_INFO > 0 then
        local t = {}
        for j = 1, 10 do
            t[j] = string.unpack("f", fd:read(4))
        end
        location = t
        
        if p.type == FXNODE_TYPE_HELPER and p.modelInfo & HELPER_CAMERA_FLAG > 0 then
            location_camera = fd:read(4*3)
        end
    end

    return location, location_camera
end

function load_attached(fd, m, p)
    --print(string.format("%X", fd:seek("cur", 0)))
    local h = {}
    h.pname, h.pnameLen = load_name(fd)
    h.name, h.nameLen = load_name(fd)
    h.type = string.unpack("I", fd:read(4))
    
    h.modelInfo = load_node_info(fd, m, p)
    h.location = load_location(fd, m, h)
end

function load_material(fd, m, p)
    --print("[MTL]", string.format("%X", fd:seek("cur", 0)))
    local frame = m.endframe - m.startframe + 1
    
    local mat = {}
    mat.node = m
    mat.name, mat.nameLen = load_name(fd)
    mat.indexInNode = string.unpack("i", fd:read(4))

    mat.materialInfo = load_material_info(fd, m, p, mat)
    if mat.materialInfo & MATERIAL_FLAG_EXT > 0 then
        mat.materialInfoEx = string.unpack("I", fd:read(4))
    else
        mat.materialInfoEx = 0
    end
    
    mat.vertexCount = string.unpack("I", fd:read(4))
    assert(mat.vertexCount < 0x10000)
    
    mat.singleVertexSize = 0
	mat.multiVertexSize = 0
	
	-- Position 
	if p.modelInfo & MODEL_POSITION_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 3
	elseif p.modelInfo & MODEL_POSITION_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4 * 3
	end

	-- Normal
	if p.modelInfo & MODEL_NORMAL_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 3
	elseif p.modelInfo & MODEL_NORMAL_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4 * 3
	end

	-- Color
	if p.modelInfo & MODEL_COLOR_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4
	elseif p.modelInfo & MODEL_COLOR_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4
	end

	-- Illum
	if p.modelInfo & MODEL_ILLUM_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4
	elseif p.modelInfo & MODEL_ILLUM_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4
	end

	-- Tangent
	if p.modelInfo & MODEL_TANGENT_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 3
	elseif p.modelInfo & MODEL_TANGENT_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4 * 3
	end

	-- Binormal
	if p.modelInfo & MODEL_BINORMAL_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 3
	elseif p.modelInfo & MODEL_BINORMAL_ANI > 0 then
		mat.multiVertexSize = mat.multiVertexSize + 4 * 3
	end

	-- Diffuse texture
	if mat.materialInfo & (MATERIAL_DIFFUSE_MAP_INFO | MATERIAL_BUMP_MAP_INFO | MATERIAL_SPECULAR_MAP_INFO | MATERIAL_SELF_ILLUMINATION_INFO) > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 2
	end

	-- Filter texture
	if mat.materialInfoEx & MATERIAL_FILTER_MAP_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 2
	end

	-- Lightmap texture
	if mat.materialInfo & MATERIAL_LIGHTMAP_INFO > 0 then
		mat.singleVertexSize = mat.singleVertexSize + 4 * 2
	end
    
    if mat.singleVertexSize > 0 then
        mat.vertexData = fd:read(mat.singleVertexSize * mat.vertexCount)
    end
    if mat.multiVertexSize > 0 then
        mat.vertexDataList = {}
        for i = 1, frame do
            mat.vertexDataList[i] = fd:read(mat.multiVertexSize * mat.vertexCount)
        end
    end
    
    
    mat.lodIndexCount = {}
    mat.lodIndexData = {}

    for i = 1, m.lodCount do
        mat.lodIndexCount[i] = string.unpack("I", fd:read(4))
    end

    for i = 1, m.lodCount do
        local n = mat.lodIndexCount[i]
        if n > 0 then
            mat.lodIndexData[i] = fd:read(2 * n)
        end
    end

    if p.type == FXNODE_TYPE_SKIN then
        mat.weightTable = {}
        mat.skinnedVertexBonBlendVertexSize = (2 + 4) * 4
        local weightVertexNum = mat.vertexCount * 4
        for i = 1, weightVertexNum do
            local t = {}
            t.boneNameOffset = string.unpack("i", fd:read(4))
            t.weight = string.unpack("f", fd:read(4))
            t.boneId = -1
            mat.weightTable[i] = t
        end
        
        mat.boneNameListLen = string.unpack("I", fd:read(4))
        mat.boneNameList = fd:read(mat.boneNameListLen)
    end

    if mat.materialInfo & MATERIAL_AMBIENT_ANI > 0 then
        fd:read(4*3*frame)
    elseif mat.materialInfo & MATERIAL_AMBIENT_INFO > 0 then
        fd:read(4*3)
    end
    if mat.materialInfo & MATERIAL_DIFFUSE_ANI > 0 then
        fd:read(4*3*frame)
    elseif mat.materialInfo & MATERIAL_DIFFUSE_INFO > 0 then
        fd:read(4*3)
    end
    if mat.materialInfo & MATERIAL_SPECULAR_ANI > 0 then
        fd:read(4*3*frame)
    elseif mat.materialInfo & MATERIAL_SPECULAR_INFO > 0 then
        fd:read(4*3)
    end
    if mat.materialInfo & MATERIAL_EMISSIVE_ANI > 0 then
        fd:read(4*3*frame)
    elseif mat.materialInfo & MATERIAL_EMISSIVE_INFO > 0 then
        fd:read(4*3)
    end
    if mat.materialInfo & MATERIAL_OPACITY_ANI > 0 then
        fd:read(4*frame)
    elseif mat.materialInfo & MATERIAL_OPACITY_INFO > 0 then
        fd:read(4)
    end
    if mat.materialInfo & MATERIAL_GLOSS_ANI > 0 then
        fd:read(4*frame)
    elseif mat.materialInfo & MATERIAL_GLOSS_INFO > 0 then
        fd:read(4)
    end
    
    if mat.materialInfoEx & MATERIAL_FILTER_MAP_INFO > 0 then
        if mat.materialInfoEx & MATERIAL_FILTER_PARAM_ANI > 0 then
            local reverse = string.unpack("i", fd:read(4))
            fd:read(4*4*frame)
        else
            local reverse = string.unpack("i", fd:read(4))
            --hack
            if reverse > 1 then
                fd:seek("cur", -4)
            else
                fd:read(4*4)
            end
        end
    end
    
    mat.tex = {}
    if mat.materialInfo & MATERIAL_DIFFUSE_MAP_INFO > 0 then
        mat.tex.diffuseMap = load_name(fd)
        mat.diffuseMap = load_name(fd)
        
        --hack
        if m.version <= 0x1001 then
            if string.lower(string.sub(mat.tex.diffuseMap, 1, 1)) == "m" then
                mat.materialInfo = mat.materialInfo | MATERIAL_DIFFUSE_UV_ANI
            end
        end
    end
    if mat.materialInfo & MATERIAL_DIFFUSE_UV_ANI > 0 then
        fd:read(4 * 7 * frame)
    end
    if mat.materialInfo & MATERIAL_BUMP_MAP_INFO > 0 then
        mat.tex.bumpMap = load_name(fd)
        mat.bumpMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_SPECULAR_MAP_INFO > 0 then
        mat.tex.specularMap = load_name(fd)
        mat.specularMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_SPECULAR_LEVEL_MAP_INFO > 0 then
        mat.tex.specularLevelMap = load_name(fd)
        mat.specularLevelMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_GLOSSINESS_MAP_INFO > 0 then
        mat.tex.glossinessMap = load_name(fd)
        mat.glossinessMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_REFLECTION_ENV_MAP_INFO > 0 then
        mat.tex.reflectionMap = load_name(fd)
        mat.reflectionMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_LIGHTMAP_INFO > 0 then
        mat.tex.lightMap = load_name(fd)
        mat.lightMap = load_name(fd)
    end
    if mat.materialInfo & MATERIAL_SELF_ILLUMINATION_INFO > 0 then
        mat.tex.emissiveMap = load_name(fd)
        mat.lightMap = load_name(fd)
    end
    
    if mat.materialInfoEx & MATERIAL_FRAME_INFO > 0 then
        fd:read(4 * frame)
    end

    if mat.materialInfoEx & MATERIAL_FILTER_MAP_INFO > 0 then
        mat.tex.filterMap = load_name(fd)
        mat.filterMap = load_name(fd)
        
        if mat.materialInfoEx & MATERIAL_FILTER_UV_ANI > 0 then
            fd:read(4 * 7 * frame)
        end
    end

    --hack
    local fpos = fd:seek("cur", 0)
    while true do
        local n = string.unpack("i", fd:read(4))
        if n == 0 or n >= 0x100 then
            break
        end
        local s = fd:read(n)
        if s and string.match(s, "Map$") then
            print(s)
            print(load_name(fd))
            fpos = fd:seek("cur", 0)
        else
            break
        end
    end
    fd:seek("set", fpos)
    
    
    
    --[[
    for k,v in pairs(mat) do
        if k ~= "vertexData" then
            print(k, v)
        end
    end
    --]]
    return mat
end

function load_node_info(fd, m, p)
    if m.version >= 0x1002 then
        return string.unpack("I", fd:read(4))
    end
    local s = p.name
    local t = 0x00000000
    if string.sub(s,1,1) == "p" then
        t = t | MODEL_POSITION_INFO
    end
    if string.sub(s,1,1) == "P" then
        t = t | MODEL_POSITION_ANI
    end
    if string.sub(s,2,2) == "n" then
        t = t | MODEL_NORMAL_INFO
    end
    if string.sub(s,2,2) == "N" then
        t = t | MODEL_NORMAL_ANI
    end
    if string.sub(s,3,3) == "c" then
        t = t | MODEL_COLOR_INFO
    end
    if string.sub(s,3,3) == "C" then
        t = t | MODEL_COLOR_ANI
    end
    if string.sub(s,4,4) == "i" then
        t = t | MODEL_ILLUM_INFO
    end
    if string.sub(s,4,4) == "I" then
        t = t | MODEL_ILLUM_ANI
    end
    if string.sub(s,5,5) == "t" then
        t = t | MODEL_TANGENT_INFO
    end
    if string.sub(s,5,5) == "T" then
        t = t | MODEL_TANGENT_ANI
    end
    if string.sub(s,6,6) == "b" then
        t = t | MODEL_BINORMAL_INFO
    end
    if string.sub(s,6,6) == "B" then
        t = t | MODEL_BINORMAL_ANI
    end
    if string.sub(s,7,7) == "m" then
        t = t | MODEL_MATRIX_INFO
    end
    if string.sub(s,7,7) == "M" then
        t = t | MODEL_MATRIX_ANI
    end

    return t
end

function load_material_info(fd, m, p, mat)
    if m.version >= 0x1002 then
        return string.unpack("I", fd:read(4))
    end
    local s = mat.name
    local t = 0x00000000
    if string.sub(s,1,1) == "a" then
        t = t | MATERIAL_AMBIENT_INFO
    end
    if string.sub(s,1,1) == "A" then
        t = t | MATERIAL_AMBIENT_ANI
    end
    if string.sub(s,2,2) == "d" then
        t = t | MATERIAL_DIFFUSE_INFO
    end
    if string.sub(s,2,2) == "D" then
        t = t | MATERIAL_DIFFUSE_ANI
    end
    if string.sub(s,3,3) == "s" then
        t = t | MATERIAL_SPECULAR_INFO
    end
    if string.sub(s,3,3) == "S" then
        t = t | MATERIAL_SPECULAR_ANI
    end
    if string.sub(s,4,4) == "e" then
        t = t | MATERIAL_EMISSIVE_INFO
    end
    if string.sub(s,4,4) == "E" then
        t = t | MATERIAL_EMISSIVE_ANI
    end
    if string.sub(s,5,5) == "o" then
        t = t | MATERIAL_OPACITY_INFO
    end
    if string.sub(s,5,5) == "O" then
        t = t | MATERIAL_OPACITY_ANI
    end
    if string.sub(s,6,6) == "g" then
        t = t | MATERIAL_GLOSS_INFO
    end
    if string.sub(s,6,6) == "G" then
        t = t | MATERIAL_GLOSS_ANI
    end

    if string.lower(string.sub(s,8,8)) == "d" then
        t = t | MATERIAL_DIFFUSE_MAP_INFO
    end
    if string.lower(string.sub(s,9,9)) == "b" then
        t = t | MATERIAL_BUMP_MAP_INFO
    end
    if string.lower(string.sub(s,10,10)) == "s" then
        t = t | MATERIAL_SPECULAR_MAP_INFO
    end
    if string.lower(string.sub(s,11,11)) == "l" then
        t = t | MATERIAL_SPECULAR_LEVEL_MAP_INFO
    end
    if string.lower(string.sub(s,12,12)) == "g" then
        t = t | MATERIAL_GLOSSINESS_MAP_INFO
    end
    if string.lower(string.sub(s,13,13)) == "r" then
        t = t | MATERIAL_REFLECTION_ENV_MAP_INFO
    end
    if string.lower(string.sub(s,14,14)) == "i" then
        t = t | MATERIAL_LIGHTMAP_INFO
    end
    
    local doubleSide = string.unpack("I", fd:read(4))
    return t, doubleSide
end
















local hash = {}
function hash_mark(key)
    hash[key] = (hash[key] or 0) + 1
end
local fail = {}
function fail_mark(v, ver)
    table.insert(fail, {v, ver})
    hash_mark("_EEEEEEEEEEE_LoadFailed"..tostring(ver))
end


--local path = "D:\\jiuyin\\res"
local path = "E:\\artwork\\JiuYinRes"
local list = lsdir(path, "%.xmod$")
--local list = {"E:\\artwork\\JiuYinRes\\map_obj.package.files\\res\\map\\obj\\effect\\e_door.xmod"}
for i,v in ipairs(list) do
    print(v)
    local fd = io.open(v, "rb")
    if fd then
        local m, msg = load_xmod(fd)
        if m then
            hash_mark("version"..string.format("%X", m.version))
            hash_mark("fileType"..m.fileType)
            hash_mark("rootNodeCount"..m.rootNodeCount)
            
            local cnt = {0,0,0,0,0}
            for i,v in ipairs(m.rootNodes) do
                hash_mark("NodeType"..v.type)
                hash_mark("childNodeCount"..v.childNodeCount)
                
                if v.attachedHelperCount then
                    hash_mark("NodeAttachedHelperCount"..v.attachedHelperCount)
                end
                
                cnt[v.type] = cnt[v.type] + 1
            end
            for i,v in ipairs(cnt) do
                hash_mark("rootNodeType"..i.."="..v)
            end
        else
            fail_mark(v, msg)
        end
        fd:close()
    end
end

print("\n\n===============info================\n")
for i,v in ipairs(fail) do
    print(v[1], v[2])
end
print("===============fail================", #fail, "\n")
local data = {}
for k,v in pairs(hash) do
    table.insert(data, {k,v})
end
table.sort(data, function(a,b) return a[1] < b[1] end)
for i,v in ipairs(data) do
    print(v[1], v[2])
end
print("===============load================", #list, "\n")
    
    
    
    
