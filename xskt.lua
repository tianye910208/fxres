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


SKELETON_SCALEINFO_FLAG	    = 0x00000001
SKELETON_TRANSLATEINFO_FLAG = 0x00000002
SKELETON_HELPERANI_FLAG     = 0x00000004

function load_xskt(fd)
    local m = {}
    m.flag = fd:read(4)
    if m.flag ~= "XSAM" then
        return nil, "_FLAG_"..tostring(m.flag)
    end
    m.version, m.fileType = string.unpack("II", fd:read(8))
    if m.version ~= 0x1003 and m.version ~= 0x1004 and m.version ~= 0x1005 then
        --print("load xmod "..string.format("0x%04X", m.version))
        return nil, "_V_"..string.format("%X", m.version)
    end
    
    
    m.name, m.nameLen = load_name(fd)
    m.startframe, m.endframe, m.fps = string.unpack("IIf", fd:read(12))
    
    m.rootMinX, m.rootMinY, m.rootMinZ = string.unpack("fff", fd:read(12))
    m.rootMaxX, m.rootMaxY, m.rootMaxZ = string.unpack("fff", fd:read(12))
   
    m.rootNodeCount = string.unpack("I", fd:read(4))
    m.rootNodes = {}
    
    --[[
    print("[Xskt]--------------", m.name)
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

function load_node(fd, m, parent)
    --print(string.format("[NODE] %X", fd:seek("cur", 0)))
    local p = {}
    p.parent = parent
    p.name, p.nameLen = load_name(fd)
    p.type = string.unpack("I", fd:read(4))
    
    --hack
    if p.type == 1 then
        p.type = FXNODE_TYPE_BONE
    elseif p.type == 2 then
        p.type = FXNODE_TYPE_HELPER
    end
    
    if p.type ~= FXNODE_TYPE_BONE and p.type ~= FXNODE_TYPE_HELPER then
        error("load node fail "..tostring(p.type))
    end
    
    p.modelInfo = load_node_info(fd, m, p)
    
    if p.type == FXNODE_TYPE_BONE then
        p.active = string.unpack("I", fd:read(4))
    end
    --print(string.format("111 %X", fd:seek("cur", 0)))
    --location matrix
    p.location = load_location(fd, m, p)
    
    --print(string.format("222 %X", fd:seek("cur", 0)))
    p.childNodeCount = string.unpack("I", fd:read(4))
    p.childNodes = {}
    
    --[[
    print("[Node]--------------", p.name)
    for k,v in pairs(p) do
        if k ~= "location" then
            print(k, v)
        end
    end
    --]]
    
    for i = 1, p.childNodeCount do
        local c = load_node(fd, m, p)
        p.childNodes[i] = c
    end
    return p
end


function load_location(fd, m, p)
    local location = nil
    
    if p.active == 1 or p.modelInfo & SKELETON_HELPERANI_FLAG > 0 then
        local frame = m.endframe - m.startframe + 1
        local lsize = get_location_size(fd, m, p)
        location = fd:read(lsize)
    else
        local lsize = 4 * 10
        location = fd:read(lsize)
    end

    return location
end


function get_location_size(fd, m, p)
    local frame = m.endframe - m.startframe + 1
    local n = 4 * 10
    
    local f1 = p.modelInfo & SKELETON_TRANSLATEINFO_FLAG > 0
    local f2 = p.modelInfo & SKELETON_SCALEINFO_FLAG > 0
    
    if f1 and f2 then
        n = n + (frame - 1) * 4 * 10 -- pos3f rot4f scale3f
    elseif f1 then
        n = n + (frame - 1) * (2 * 3 + 4 * 3)--rot3short pos3f
    elseif f2 then
        n = n + (frame - 1) * (2 * 3 + 4 * 3)--rot3short scale3f
    else
        n = n + (frame - 1) * 2 * 3 --rot3short
    end
    --print(frame, n, f1, f2)
    return n
end

function load_node_info(fd, m, p)
    if m.version >= 0x1005 then
        return string.unpack("I", fd:read(4))
    end
    local t = 0
    if m.version == 0x1004 then
        if string.unpack("I", fd:read(4)) == 1 then
            t = t | SKELETON_SCALEINFO_FLAG
        end
    end
    
    if string.find(p.name, "!T") or p.parent == nil then
        t = t | SKELETON_TRANSLATEINFO_FLAG
    end
    
    if p.type == FXNODE_TYPE_HELPER and string.sub(p.name, 7, 7) == "M" then
        t = t | SKELETON_HELPERANI_FLAG
    end
    
    return t
end









local hash = {}
function hash_mark(key)
    hash[key] = (hash[key] or 0) + 1
end
local fail = {}
function fail_mark(v, msg)
    table.insert(fail, {v, msg})
    hash_mark("_EEEEEEEEEEE_LoadFailed"..tostring(msg))
end

local path = "D:\\jiuyin\\res"
--local path = "E:\\artwork\\JiuYinRes"
local list = lsdir(path, "%.xskt$")
--local list = {[[E:\artwork\JiuYinRes\map_mdl.package.files\res\map\mdl\animation\scene\worldnpc141\stand.xskt]]}
for i,v in ipairs(list) do
    print(v)
    local fd = io.open(v, "rb")
    if fd then
        local m, msg = load_xskt(fd)
        if m then
            hash_mark("version"..string.format("%X", m.version))
            hash_mark("fileType"..m.fileType)
            hash_mark("rootNodeCount"..m.rootNodeCount)
            
            local cnt = {0,0,0,0,0}
            for i,v in ipairs(m.rootNodes) do
                hash_mark("NodeType"..v.type)
                hash_mark("childNodeCount"..v.childNodeCount)
                
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
    
    
    
