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
  s.metadata = {
    "homepage_uri" => s.homepage,
    "source_code_uri" => s.homepage
  }
  s.add_runtime_dependency 'rails', '>= 7.1'
  s.add_development_dependency 'rake'
  s.required_ruby_version = '>= 3.1.0'
  s.license = 'MIT'
end