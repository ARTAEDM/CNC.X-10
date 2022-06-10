-- создание таблицы: ТЕХКОМАНДА - ОПИСАНИЕ
--[[
function getFileList(dir)
 local res={}
 local req=string.format('dir "%s" /b /a-d',dir);
 res = io.popen(req):lines()
 return res
end
--]]
local function getFileList(dir,ext)
 local res={}
 local req=string.format('cd "%s"; ls -X -1 %s',dir,ext)
 res = io.popen(req):lines()
 return res
end

function exists(tab, element)
    local v
    for _, v in pairs(tab) do
        if v == element then
            return true
        elseif type(v) == "table" then
            return exists(v, element)
        end
    end
    return false
end

function parseFile(file,tab)
 local curfile = io.open(file, "r");
 local n
 if curfile then 
  for line in curfile:lines() do
   local nm,hdr = string.match(line,'^%-%-%sM(%d+)%s(.+)');
   
   if nm and hdr then
    n = tonumber(nm);
    tab[n] = {}
    tab[n].hdr = hdr
   else
    local a,val = string.match(line,'^%-%-%s@(%a+)%s(.+)');
    if n and a and val then
     tab[n][a] = val
    else
     break;
    end
   end
  end
  curfile:close();
 end
end


function parseDir(dir,tab,ext)
 local root = getFileList(dir,ext);
 for file in root do parseFile(dir .. '/' .. file,tab) end
end

local str={}

parseDir('/home/kirill/WORK/BORA/ACNC/LUA',str,'M*.lua');


print('| КОМАНДА | ОПИСАНИЕ | АРГУМЕНТЫ | ПРИМЕРЫ |')
print('|---------|----------|-----------|---------|')
for i=0,999 do
 if str[i] then
  print('| M'..i,' | ',str[i].hdr,' | ',str[i].arg or ' ',' |',str[i].inf or ' ','|')
 end
end
