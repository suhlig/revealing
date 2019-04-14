REVEAL_JS_VERSION = '3.7.0'.freeze
prereq 'curl'

desc 'reveal.js is present'
directory REVEAL_JS_TARGET_DIR => ['curl', TARGET_DIR] do |target|
  mkdir target.name

  if ENV['REVEAL_JS_DIR'].to_s.empty?
    warn "Downloading reveal.js #{REVEAL_JS_VERSION}. Set REVEAL_JS_DIR in order to use a cached version."
    sh "curl --location https://github.com/hakimel/reveal.js/archive/#{REVEAL_JS_VERSION}.tar.gz | tar xz -C #{target.name} --strip-components 1"
  else
    warn "Using cached version of reveal.js from #{ENV['REVEAL_JS_DIR']}"
    cp_r FileList["#{ENV['REVEAL_JS_DIR']}/."], target.name, remove_destination: true
  end
end
