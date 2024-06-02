# frozen_string_literal: true

require_relative "lib/country_options_select/version"
  
Gem::Specification.new do |s|
  s.name = 'country_options_select'
  s.homepage = 'https://github.com/JMarst/country_options_select'
  s.authors = ['Jon Marston']
  s.version = CountryOptionsSelect::VERSION
  s.files = Dir['lib/**/*'] + %w(README.md MIT-LICENSE)
  s.test_files = Dir['test/**/*']
  s.require_path = 'lib'
  s.summary = 'Capital, Currency and Dial Code form select helpers using CountriesSpace.now API'
  s.add_runtime_dependency 'rails', '>= 6.1'
  s.add_development_dependency 'rake'
  s.license = 'MIT'
end