require 'rake/clean'
require 'pathname'
require 'git-dirty'

SOURCE_DIR = 'src'.freeze

TARGET_DIR = Pathname('public_html')
directory TARGET_DIR
TARGET_FILE = TARGET_DIR / 'index.html'

GPP_DIR = Pathname('gpp')
directory GPP_DIR
DIRTY_FILE = GPP_DIR / '.dirty'
GPP_FILES = FileList["#{GPP_DIR}/index.markdown"]

CLEAN.include GPP_DIR, DIRTY_FILE
CLOBBER.include TARGET_DIR

REVEAL_JS = "reveal.js".freeze
REVEAL_JS_TARGET_DIR = TARGET_DIR / REVEAL_JS
REVEAL_JS_VERSION = '3.7.0'.freeze

RESIZABLE_ASSETS = (FileList["assets/*.png"] + FileList["assets/*.jpg"])
RESIZED_ASSETS = RESIZABLE_ASSETS.pathmap("#{TARGET_DIR}/%f")
ASSET_SOURCES = FileList['assets/*'] - RESIZABLE_ASSETS
ASSETS = ASSET_SOURCES.pathmap("#{TARGET_DIR}/%f") - RESIZED_ASSETS

load "#{__dir__}/tasks/assets.rake"
load "#{__dir__}/tasks/reveal.js.rake"
load "#{__dir__}/tasks/gpp.rake"

git_dirty_file DIRTY_FILE

desc "Build #{TARGET_FILE}"
file TARGET_FILE => [ TARGET_DIR, REVEAL_JS_TARGET_DIR, GPP_FILES, DIRTY_FILE ] + ASSETS + RESIZED_ASSETS do
  sh %(pandoc
      --to=revealjs
      --standalone
      --highlight-style zenburn
      --slide-level=1
      --output #{TARGET_FILE}
      --variable theme=white
      --variable slideNumber=true
      --variable history=true
      --variable revealjs-url=#{REVEAL_JS}
      --include-in-header=#{TARGET_DIR}/customizations.css
    #{GPP_FILES}
  ).split("\n").join(' ')
end
