# frozen_string_literal: true

require 'rake/testtask'

desc 'Default: run unit tests'
task :default => :test

desc 'Test FormTagHelper'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.test_files = [File.expand_path('../test/form_tag_helper_test.rb', __FILE__)]
  t.verbose = true
end