-- https://github.com/Donearm/scripts/blob/master/lib/dirname.lua
local function dirname(str)
	if str:match(".-/.-") then
		return string.gsub(str, "(.*/)(.*)", "%1")
	else
		return '.'
	end
end

local function convertToSVG(text, scale)
	return pandoc.pipe(
		"java",
		{
			"-Djava.awt.headless=true",
			"-jar", dirname(PANDOC_SCRIPT_FILE) .. '/' .. "lib/ditaa-0.11.0-standalone.jar",
			"-",
			"-",
			"--svg",
			"--scale", scale
		},
		text
	)
end

-- These formats accept embedded SVG
local SUPPORTED_FORMATS = {
	['html'] = true, ['html5'] = true, ['html4'] = true, ['slideous'] = true,
	['slidy'] = true, ['dzslides'] = true, ['revealjs'] = true, ['s5'] = true
}

function CodeBlock(block)
  if not (block.classes[1] == "ditaa") then
		return -- keeps the block's text as literal code block
	end

	if not SUPPORTED_FORMATS[FORMAT] then
		io.stderr:write(string.format("Warning: Cannot convert DITAA block to SVG for format %s. Keeping literal value.\n", FORMAT))
		return
	end

  local scale = block.attributes["scale"] or "1.0"

	success, result = pcall(convertToSVG, block.text, scale)

	if not success then
		io.stderr:write(string.format("Error - DITAA block could not converted:\n%s\n", result.output))
	else
		-- io.stderr:write("DITAA block converted successfully\n")
		return pandoc.Para({pandoc.RawInline("html", result)})
	end
end
