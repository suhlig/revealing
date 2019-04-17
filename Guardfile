# frozen_string_literal: true

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new
  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }
  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch('spec/spec_helper.rb') { %w(spec/unit spec/system) }
end

group 'unit' do
  guard :rspec, cmd: 'bundle exec rspec' do
    watch(%r{^spec/unit/.+_spec\.rb$})
    watch(%r{^lib/.+/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  end
end

group 'system' do
  guard :rspec, cmd: 'bundle exec rspec' do
    watch(%r{^spec/system/.+_spec\.rb$})
    watch(%r{^lib/.+/(.+)\.rb$}) { |m| "spec/system/#{m[1]}_spec.rb" }
  end
end
