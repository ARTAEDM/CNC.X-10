-- добавить настройки цветов в конфигурацию

-- локальные функции управления конфигурацией

function string:startswith(start)
    return self:sub(1, #start) == start
end

local function execute(val)
 print(val)
 local openPop = assert(io.popen(val)) --, 'r'
 local output = openPop:read('*a')
 openPop:close()
 return output
end

local function sleep(n)
 execute('sleep '..tostring(n))
end

local function rw()
 execute('/CNC/sysmode rw')
 sleep(1)
end
local function ro()
 execute('/CNC/sysmode ro')
 sleep(1)
end

local function readFile(name,act)
 local f=io.open(name)
 if f==nil then return "" end
 if act==nil then act='a' end
 local res = f:read(act)
 f:close()
 return res
end

local function readFileToLines(name)
 local res={}
 local file = io.open(name)
 local line = file:read("*l")
 while line do
  res[#res + 1] = line
  line = file:read("*l")
 end
 file:close()
 return res
end

local function writeFileFromLines(name,lines)
 local f=io.open(name,"w")
 if f==nil then return false end

 for i=1,#lines do
  if not f:write(lines[i] .. "\n") then return false end
 end

 f:close()

 return true
end

local function printLines(lines)
 for i=1,#lines do
  print(lines[i])
 end
end

local function delIncludeFromLines(lines,name)
 for i=#lines,1,-1 do
  
  local s,e = lines[i]:find('#include%s+"'..name..'"')
  
  if s then 
   -- нашли
   print(i,s,e,lines[i]);
   if s==1 then
    lines[i] = ';#include "'..name..'"';
    break;
   end
   --partInd=i;break 
  end
 end

end

local function addIncludeToLines(lines,name)
 for i=#lines,1,-1 do
  
  local s,e = lines[i]:find('#include%s+"'..name..'"')
  
  if s then 
   -- нашли
   print(i,s,e,lines[i]);
   if s==1 then
    break;
   else
    lines[i] = '#include "'..name..'"';
    break;
   end
   --partInd=i;break 
  end
 end

end

local function setValueToLines(lines,part,name,value)
 -- 1 ищем раздел
 local partInd = 0
 local valInd  = 0
 for i=#lines,1,-1 do
  if lines[i]:startswith(part) then partInd=i;break end
 end
 
 if partInd == 0 then
  -- 2 нет раздела, просто добавляем в конец
  lines[#lines+1] = part
  lines[#lines+1] = name .. "=" .. value
 else
  -- 3 есть раздел
  for i=partInd+1,#lines do
   if lines[i]:startswith("[") then break end
   if lines[i]:startswith(name) then valInd=i end
  end

  if valInd == 0 then
   -- 4 нет значения, добавляем в начало раздела
   table.insert(lines,partInd+1,name .. "=" .. value)
  else
   -- 5 есть значение, заменяем
   lines[valInd] = name .. "=" .. value
  end
 end
end


local cfgFile = "/CNC/CFG/"..readFile("/CNC/CFG/cur.cfg","*l")
-- читаем весь файл в массив строк
local org = readFileToLines(cfgFile)
rw()
setValueToLines(org,"[color]","prg.border","#422100") -- границы поля       
setValueToLines(org,"[color]","prg.back",  "#002142") -- пассивный фон      
setValueToLines(org,"[color]","prg.aback", "#003263") -- активный фон       
setValueToLines(org,"[color]","prg.grid",  "#424242") -- сетка              
setValueToLines(org,"[color]","prg.mark",  "#ffffff") -- метки              
setValueToLines(org,"[color]","prg.org",   "#ffffff") -- оригинальный контур
setValueToLines(org,"[color]","prg.up",    "#ffff00") -- верхний            
setValueToLines(org,"[color]","prg.dw",    "#00ff00") -- нижний             
setValueToLines(org,"[color]","prg.skup",  "#a0a0a4") -- макет верхний      
setValueToLines(org,"[color]","prg.skdw",  "#a0a0a4") -- макет нижний       
writeFileFromLines(cfgFile,org)
ro()

