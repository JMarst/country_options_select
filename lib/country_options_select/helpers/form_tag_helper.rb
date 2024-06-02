# frozen_string_literal: true
  
class CountryOptionsSelect
  module FormTagHelper
    %w(currency dial_code capital).each do |select_type|
      define_method("country_#{select_type}_select_tag") do |name, **options|
        country_options_select_tag(select_type, name, options)
      end
    end

    private
      def country_options_select_tag(select_type, name, options)
        options = options.dup
        country_select_tag_options = options.extract!(*%i(text_format updates removals options_override order selected disabled html_attributes))

        select_tag(name, send("country_#{select_type}_for_select", **country_select_tag_options), options)
      end
  end
end