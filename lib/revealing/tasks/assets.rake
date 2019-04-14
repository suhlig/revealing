prereq 'gm'

RESIZED_ASSETS.zip(RESIZABLE_ASSETS).each do |target, source|
  desc "Resize #{source} to #{target}"
  file target => ['gm', source] do
    sh "gm convert #{source} -geometry '1920x1080>' #{target}"
  end
end

ASSETS.zip(ASSET_SOURCES).each do |target, source|
  desc "Copy #{source} to #{target}"
  file target => ['gm', source] do
    cp source, target
  end
end
