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

--local path = "E:\\artwork\\JiuYinRes\\obj_char_g.package.files"
local path = "D:\\jiuyin\\res"

local hash = {}
local list = lsdir(path, "%.xskt$")
for i,v in ipairs(list) do
    --print(v)
    local fd = io.open(v, "rb")
    if fd then
        local h = fd:read(4)
        local t = fd:read(4)
        
        if h and t then
            local m = "0x"..
                    string.format("%02x", string.byte(t, 4))..
                    string.format("%02x", string.byte(t, 3))..
                    string.format("%02x", string.byte(t, 2))..
                    string.format("%02x", string.byte(t, 1))
            
            
            local cn1 = hash[h] or 0
            hash[h] = cn1 + 1
            local cn2 = hash[m] or 0
            hash[m] = cn2 + 1
        else
            print(h, t, v)
        end
        fd:close()
    end
end
print(#list)
for k,v in pairs(hash) do
    print(k, v)
end
    
    
    