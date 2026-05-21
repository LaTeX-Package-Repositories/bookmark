#!/usr/bin/env texlua


module = "bookmark"

textfiles = {"README.md"}
typesetfiles = {"bookmark.dtx"}
installfiles={"*.sty","*.tex","*.def"}

checkconfigs = {"build"}
checkengines =  {"pdftex","luatex"}

packtdszip  = false

maxprintline=10000
checkruns = 2
recordstatus=true

specialformats = specialformats or {}
specialformats["latex"] = specialformats["latex"] or
  {
    luatex     = {binary="luahbtex",format = "lualatex-dev"},
  }

typesetexe = "lualatex-dev"
typesetruns = 4
function docinit_hook() 
cp("bkm-luatex.def", unpackdir, typesetdir)
return cp("bookmark.sty", unpackdir, typesetdir) end


tdslocations={
"doc/latex/bookmark/bookmark-example.tex",
"tex/latex/bookmark/bookmark.sty",
"tex/latex/bookmark/bkm-dvipdfmx.def",
"tex/latex/bookmark/bkm-dvips.def",
"tex/latex/bookmark/bkm-pdftex.def",
"tex/latex/bookmark/bkm-luatex.def",
"tex/latex/bookmark/bkm-xetex.def",
"tex/latex/bookmark/bkm-vtex.def",
}

tagfiles={"README.md", "*.dtx", "*.ins"}

function update_tag(file,content,tagname,tagdate)

local tagpattern="(%d%d%d%d[-/]%d%d[-/]%d%d) v(%d+[.])(%d+)"
local oldv,newv
if tagname == 'auto' then
  content = string.gsub (content,
                         "2016%-%d%d%d%d",
                         "2016-"..os.date("%Y"))    
  local i,j,olddate,a,b
  i,j,olddate,a,b= string.find(content, tagpattern)
  if i == nil then
    print('OLD TAG NOT FOUND')
    return content
  else
    print ('FOUND: ' .. olddate .. ' v' .. a .. b )
    oldv = olddate .. ' v' .. a .. b
    newv = tagdate .. ' v'  .. a .. math.floor(b + 1)
    print('USING OLD TAG: ' .. oldv)
    print('USING NEW TAG: ' .. newv)
    local oldpattern = string.gsub(oldv,"[-/]", "[-/]")
    content=string.gsub(content,"{Version}{" .. oldpattern,'##OLDV##')
    content=string.gsub(content,oldpattern,newv)
    content=string.gsub(content,'##OLDV##',"{Version}{" .. oldv)
    content=string.gsub(content,'%-%d%d%d%d Oberdiek Package','-' .. os.date("%Y") .. " Oberdiek Package")
    content = string.gsub(content,
        '%% \\end{History}',
	'%%   \\begin{Version}{' .. newv .. '}\n%%   \\item Updated\n%%   \\end{Version}\n%% \\end{History}')
    return content
  end
else
  error("only automatic tagging supported")
end

end


