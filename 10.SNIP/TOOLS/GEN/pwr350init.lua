-- КАЛИБРОВКА ДАТЧИКА НАПРЯЖЕНИЯ ГЕНЕРАТОРА

local function calibrate()
 -- Отключить аварию и слежение
 setSysVal(0422,0)
 sys:setInternal('WRK-CTRL','0')
 sys:setInternal('WRK-FAIL','0')
 gen.Mode = "РАБОЧИЙ" -- Рабочий режим
 gen.F = 1 -- Частота 1

 local adr = getSysNum('gen/vlt.ain')
 local vlist = {100,150,200,250,300,350};

 local file = io.open(sys:getPathUSB() .. '/' .. 'genVlTab'..'.txt', 'w'); -- открываем файл

 local function mes(V)
  local val = unio:getAin(adr)
  sys:SLEEP(100);
  val = val + unio:getAin(adr)
  sys:SLEEP(100);
  val = val + unio:getAin(adr)
  sys:SLEEP(100);
  val = val + unio:getAin(adr)
  sys:SLEEP(100);
  val = val + unio:getAin(adr)
  val = val / 5;

  file:write('V:' .. tostring(V)..' = ' .. string.format("%4.0f",val),'\n');
  return val
 end

 local res={}

 if gen:isGenerate() then
  gen:OFF()
  sys:SLEEP(45000);
 end

 res[#res+1] = mes(0)

 gen.V = vlist[1]
 gen:ON()

 for ind,V in ipairs(vlist) do
  gen.V = V
  sys:SLEEP(15000);
  res[#res+1] = mes(V)
 end

 gen:OFF()

 local answ=''

 file:write('vlt.cnv.TAB="')
 --vlt.cnv.TAB="254=350;291=300;542=250;741=200;1043=150;1290=100;1777=0"
 if res[1] > res[2] then
  -- reverce
  for i=#res,1,-1 do
   local tmp = string.format('%.0f=%d',res[i],vlist[i-1] or 0)
   file:write(tmp);answ=answ..tmp
   if i>1 then file:write(';');answ=answ..';' end
  end
 else
  -- normal
  for i=1,#res do
   local tmp = string.format('%.0f=%d',res[i],vlist[i-1] or 0) 
   file:write(tmp);answ=answ..tmp
   if i<#res then file:write(';');answ=answ..';' end
  end
 end
 file:write('"\n')
 file:close() -- закрываем файл

 return answ
end
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
--printLines(org)

local answ = '"'..calibrate()..'"'
rw()
setValueToLines(org,"[gen]","vlt.cnv.TAB",answ)
writeFileFromLines(cfgFile,org)
ro()
--printLines(org)

