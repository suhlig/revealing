prereq 'gm'

def refute_duplicate_basename(assets)
  assets = assets.map{ |f| Pathname(f) }
  basenames = assets.map{ |f| f.basename }

  if basenames.length != basenames.uniq.length
    # https://stackoverflow.com/a/8922931/3212907
    duplicate_basenames = basenames.select{ |e| basenames.count(e) > 1 }.uniq
    list = assets.select{ |a| duplicate_basenames.include?(a.basename) }
    warn "Error: The following assets have the same base name and would override another in the output:"
    warn ''
    warn list.join("\n")
    warn ''
    warn "Consider renaming them to be unique."
    fail
  end
end

refute_duplicate_basename(RESIZABLE_ASSETS)

RESIZED_ASSETS.zip(RESIZABLE_ASSETS).each do |target, source|
  desc "Resize #{source} to #{target}"
  file target => ['gm', source] do
    sh "gm convert #{source} -geometry '1920x1080>' #{target}"
  end
end

refute_duplicate_basename(ASSET_SOURCES)

ASSETS.zip(ASSET_SOURCES).each do |target, source|
  desc "Copy #{source} to #{target}"
  file target => source do
    cp source, target
  end
end
