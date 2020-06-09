-- (C) PureAsbestos, 2020
-- Distributed under the MIT License
-- Attribution welcome, but not required


-- this script requires lua-gd
gd = require("gd")


--[ HELPER FUNCTIONS ]--

-- unpack for lua < 5.2
function unpack_ (t, i)
    i = i or 1
    if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
    end
end
unpack = unpack or table.unpack or unpack_

-- convert 24 bit hexidecimal to RGB triple
function hex2rgb(hx)
    hx = hx:gsub("#","")
    return tonumber("0x"..hx:sub(1,2)), tonumber("0x"..hx:sub(3,4)), tonumber("0x"..hx:sub(5,6))
end

-- split a string with the given separator (whitespace by default)
function split(str, sep)
    sep = sep or "%s"
    local t={}
    for s in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(t, s)
    end
    return t
end

--[------------------]--



function main()

--[ CMD LINE ARGS ]--

local palette = split(arg[1], ',')
local output_loc = arg[2] or "out.png"
local options = split(arg[3] or "0,10,70,255,128,48,1,0,0", ',')

for i, num in ipairs(options) do 
    options[i] = tonumber(num)
end

--[---------------]--



--[ HACKY STUFF ]--

-- create image
local image = gd.create(640, 432)

-- give palette to image
for _, hx in ipairs(palette) do
    local r, g, b = hex2rgb(hx)
    image:colorAllocate(r, g, b)
end

num_colors = image:colorsTotal()

-- fill in full size of palette
while image:colorsTotal() < 256 do
    image:colorAllocate(image:red(0), image:green(0), image:blue(0))
end

-- initialize foreground and background colors
fg = image:colorClosest(255, 255, 255)
bg = image:colorClosest(0, 0, 0)

--[-------------]--



--[ API FUNCS ]--

function matchcolor(r, g, b)
    return image:colorClosest(r, g, b)
end
matchcolor2 = matchcolor

function getforecolor()
    return fg
end

function getbackcolor()
    return bg
end

function setforecolor(c)
    fg = c
end

function setbackcolor(c)
    bg = c
end

function clearpicture(c)
    image:filledRectangle(0, 0, image:sizeX() - 1, image:sizeY() - 1, c)
end

function drawfilledrect(x1, y1, x2, y2, c)
    image:filledRectangle(x1, y1, x2, y2, c)
end

function putpicturepixel(x, y, c)
    image:setPixel(x, y, c)
end

function getpicturepixel(x, y)
    return image:getPixel(x, y)
end

function getcolor(c)
    return image:red(c), image:green(c), image:blue(c)
end

function inputbox(...)
    return true, unpack(options)
end

-- functions that should do nothing
function updatescreen() end
function waitbreak() end
function setpicturesize(x, y) end -- the image size is hardcoded
function messagebox() end

--[-----------]--



-- run the analysis
dofile("pic_db_AnalyzePalette18.lua")

-- deallocate unused colors
for i=num_colors,255 do
    image:colorDeallocate(i)
end

-- write out the image file
image:pngEx(output_loc, 6)


end -- end of main


function handler(err)
    print(err)
    print("Usage: lua analysis.lua hex_color_1,hex_color_2,... [filename] [NOBG,CBW1,CBW2,dia_sat1,dia_sat2,dia_sat3,sat_mod1,sat_mod2,sat_mod3]")
    os.exit()
end

xpcall(main, handler)
