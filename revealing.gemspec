# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'revealing/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'revealing'
  spec.version       = Revealing::VERSION
  spec.authors       = ['Steffen Uhlig']
  spec.email         = ['steffen@familie-uhlig.net']

  spec.summary       = 'Rake tasks to for reveal.js presentations'
  spec.description   = %(Provides a workflow for creating reveal.js
                         presentations. It uses pandoc to create the
                         presentation from markdown files.)
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rake'
  spec.add_dependency 'bundler'
  spec.add_dependency 'git-dirty'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec'

end
# rubocop:enable Metrics/BlockLength
