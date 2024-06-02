# frozen_string_literal: true

class CountryOptionsSelect
  cattr_accessor :country_options

  class << self
    def update_options_from_default
      self.country_options = default_options
    end

    def update_options_from_custom
      country_options.deep_merge!(custom_options).compact!
      country_options.each{|_, options| options.compact!}
    end

    def update_options_from_api
      latest_response_options = {}

      %w(dial_code currency capital).each do |option|
        iso_code_key = option == 'dial_code' ? 'code' : 'iso2'
        JSON.parse(URI("https://countriesnow.space/api/v0.1/countries/#{option == 'dial_code' ? 'codes' : option}").
             open(&:read))['data'].each do |response_options|
               unless response_options[option].blank?
                 latest_response_options[response_options[iso_code_key]] ||= {}
                 latest_response_options[response_options[iso_code_key]]['name'] ||= response_options['name'].squish
                 latest_response_options[response_options[iso_code_key]][option] = response_options[option].squish
                 latest_response_options[response_options[iso_code_key]][option].delete!(' ') if option == 'dial_code'
               end
        end
      end
      options_diff(latest_response_options, default_options)

      if latest_response_options.present?
        File.write(custom_options_path, YAML.dump(latest_response_options.deep_merge(custom_options)))
      end
    end

    def update_options(options)
      options = transform_updates(options)

      File.write(custom_options_path, YAML.dump(custom_options.deep_merge(options))) if options.present?
    end
  
    def transform_updates(options)
      options.deep_dup.
      transform_keys{|iso_code| iso_code.to_s.upcase}.
      transform_values{|select_types| select_types.transform_keys{|select_type| select_type.to_s.downcase}.
                                      slice(*%w(name currency dial_code capital))}.
      reject{|_, select_types| select_types.blank?} if options.present?
    end

    def remove_options(options)
      countries = options.deep_dup
      countries_with_select_types = countries.extract_options!.transform_keys{|country| country.to_s.upcase}.
                                    transform_values{|select_types| select_types.map{|select_type| select_type.to_s.downcase}}

      custom_options = self.custom_options
      all_current_options = default_options.merge(custom_options)

      countries.map{|country| country.to_s.upcase}.each{|country| custom_options[country] = nil if all_current_options[country]}

      countries_with_select_types.each do |country, select_types|
        select_types.each do |select_type|
          if all_current_options.dig(country, select_type)
            custom_options[country] ||= {}
            custom_options[country][select_type] = nil
          end
        end
      end

      File.write(custom_options_path, YAML.dump(custom_options)) if custom_options.present?
    end

    private
      def options_diff(new_options, old_options)
        options = new_options.dup
        old_options.each{|k, v| new_options[k] = nil if new_options[k].nil? }
        options.each{|k, v| old_options[k] == v ? new_options.delete(k) : (options_diff(v, old_options[k] || {}) if Hash === v) }
      end

      def default_options
        YAML.load_file(File.expand_path('../default_options.yml', __FILE__))
      end

      def custom_options
        File.exist?(custom_options_path) ? YAML.load_file(custom_options_path) : {}
      end

      def custom_options_path
        './config/country_options_select.yml'
      end
  end
end

require 'open-uri'
require_relative 'country_options_select/engine'