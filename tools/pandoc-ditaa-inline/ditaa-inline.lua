function CodeBlock(block)
  if block.classes[1] == "ditaa" then
    local img = pandoc.pipe("ditaa", {"-", "-", "--svg", "--scale", "1.0"}, block.text)
    return pandoc.Para({pandoc.RawInline("html", img)})
  end
end
