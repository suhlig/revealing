desc "Sources are pre-processed into #{TARGET_DIR}"
file "#{GPP_DIR}/index.markdown" => [GPP_DIR, DIRTY_FILE] + FileList["#{SOURCE_DIR}/**/*.markdown"] do |target|
  sh %(gpp -I src -x -o #{target} #{SOURCE_DIR}/index.markdown)
end
