# frozen_string_literal: true
  
class CountryOptionsSelect
  class CountryOptionsSelectTag < ActionView::Helpers::Tags::Base
    def initialize(select_type, object_name, method_name, template_object, options, html_options)
      @select_type = select_type

      options = options.dup
      @country_select_options = options.extract!(*%i(text_format updates removals options_override order selected disabled html_attributes))

      @html_options = html_options

      super(object_name, method_name, template_object, options)
    end

    def render
      select_content_tag(
        send("country_#{@select_type}_for_select", **@country_select_options), @options, @html_options
      )
    end
  end
end