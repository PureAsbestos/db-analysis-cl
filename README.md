# DB Analysis CL
Shim that allows use of DawnBringer's color analysis tool from the command-line via Lua-GD.

## Requirements
- A Lua runtime
- [Lua-GD](https://www.ittner.com.br/lua-gd/)

## How to Use
- Move the appropriate files from DB Toolbox into place:
  - `ffonts/font_mini_3x4.lua`
  - `libs/dawnbringer_lib.lua`
  - `libs/db_text.lua`
  - `scripts/pic_db_AnalyzePalette18.lua`
- `cd` into the `scripts` folder.
- Run `analysis.lua`, passing arguments in the following format: `lua analysis.lua hex_color_1,hex_color_2,... [filename] [NOBG,CBW1,CBW2,dia_sat1,dia_sat2,dia_sat3,sat_mod1,sat_mod2,sat_mod3]`

### The arguments:
- Required, colors in hex format, separated by commas without spaces (this is the palette)
- Optionally, the location/name of the output file (default is `out.png`)
- Optionally, options to pass on to the analysis script, seperated by commas without spaces (default is `0,10,70,255,128,48,1,0,0`)

#### The analysis options:
- (0 or 1) Exclude BG Color
- (0 to 100) CloseCols1 BriWeight %
- (0 to 100) CloseCols2 BriWeight %
- (0 to 255) HSB Diagram Hi Sat
- (0 to 255) HSB Diagram Med Sat
- (0 to 255) HSB Diagram Low Sat
- (0 or 1) Sat Mode: Purity
- (0 or 1) Sat Mode: HSV/HSB
- (0 or 1) Sat Mode: HSL

## Information for Linux users
### Installing lua-gd
You may have trouble installing lua-gd. Here's how I was able to install luajit and lua-gd on Ubuntu:
```bash
sudo apt install git
sudo apt install make
sudo apt install luajit
sudo apt install luarocks
sudo apt install libgd-dev
git clone https://github.com/ittner/lua-gd.git
cd lua-gd
sed -i "s/LUABIN=lua5.1/LUABIN=luajit/" Makefile
sudo luarocks make
cd ..
rm -rf lua-gd
```

You should also note that in bash, you cannot prefix your colors with `#` because that character is used to denote comments. You'll need to either remove it, or escape it with a backslash ( `\` ).

## License
This code is under the MIT License (see LICENSE)

Attribution welcome, but not required
