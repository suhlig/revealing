-- https://github.com/Donearm/scripts/blob/master/lib/dirname.lua
local function dirname(str)
	if str:match(".-/.-") then
		return string.gsub(str, "(.*/)(.*)", "%1")
	else
		return ''
	end
end

function CodeBlock(block)
  if block.classes[1] == "ditaa" then
    local img = pandoc.pipe(
      "java",
      {
        "-Djava.awt.headless=true",
        "-jar", dirname(PANDOC_SCRIPT_FILE) .. '/' .. "lib/ditaa-0.11.0-standalone.jar",
        "-",
        "-",
        "--svg",
        "--scale", "1.0"
      },
      block.text
    )
    return pandoc.Para({pandoc.RawInline("html", img)})
  end
end
