require 'rake/clean'
require 'pathname'
require 'git-dirty'

SOURCE_DIR = Pathname('src')
SOURCE_FILES = FileList[SOURCE_DIR / '**/*.markdown']

TARGET_DIR = Pathname('public_html')
directory TARGET_DIR
TARGET_FILE = TARGET_DIR / 'index.html'

GPP_DIR = Pathname('gpp')
directory GPP_DIR
DIRTY_FILE = GPP_DIR / '.dirty'
GPP_FILE = FileList[GPP_DIR / 'index.markdown']

CLEAN.include GPP_DIR, DIRTY_FILE
CLOBBER.include TARGET_DIR

REVEAL_JS = 'reveal.js'.freeze
REVEAL_JS_TARGET_DIR = TARGET_DIR / REVEAL_JS

RESIZABLE_ASSETS = (FileList[SOURCE_DIR / '**/*.png'] + FileList[SOURCE_DIR / '**/*.jpg'])
RESIZED_ASSETS = RESIZABLE_ASSETS.pathmap("#{TARGET_DIR}/%f")
ASSET_SOURCES = FileList[SOURCE_DIR / '**/*'].select{ |f| Pathname(f).file? } - RESIZABLE_ASSETS - SOURCE_FILES
ASSETS = ASSET_SOURCES.pathmap("#{TARGET_DIR}/%f") - RESIZED_ASSETS

HEADERS = FileList['headers/*'] # These are included literal; no need to copy them

load "#{__dir__}/tasks/gpp.rake"
load "#{__dir__}/tasks/assets.rake"
load "#{__dir__}/tasks/reveal.js.rake"

git_dirty_file DIRTY_FILE

MATH_JAX_VERSION = ENV.fetch('MATH_JAX_VERSION', '2.7.5')

desc "Build #{TARGET_FILE}"
file TARGET_FILE => [ TARGET_DIR, REVEAL_JS_TARGET_DIR, GPP_FILE, DIRTY_FILE] + ASSETS + RESIZED_ASSETS + HEADERS do
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
      --mathjax=https://cdnjs.cloudflare.com/ajax/libs/mathjax/#{MATH_JAX_VERSION}/MathJax.js?config=TeX-AMS_CHTML-full
      --include-in-header=#{__dir__ + '/../../templates/mathjax/config.js'}
      #{HEADERS.map { |h| "--include-in-header=#{h}" }.join("\n")}
    #{GPP_FILE}
  ).split("\n").join(' ')
end
