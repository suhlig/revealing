prereq 'gpp'

desc "Sources are pre-processed into the single #{GPP_FILE}"
file GPP_FILE => ['gpp', GPP_DIR, DIRTY_FILE] + SOURCE_FILES do |target|
  sh %(gpp -I src -x -o #{target} #{SOURCE_DIR}/index.markdown)
end
