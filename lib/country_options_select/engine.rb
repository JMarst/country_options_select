# frozen_string_literal: true

require_relative 'helpers/form_options_helper'
require_relative 'helpers/form_tag_helper'
require_relative 'helpers/select_tag'

class CountryOptionsSelect
  class Engine < Rails::Engine
    initializer 'country_options_select.select_helpers' do |app|
      ActionView::Helpers::FormOptionsHelper.include(CountryOptionsSelect::FormOptionsHelper)
      ActionView::Helpers::FormTagHelper.include(CountryOptionsSelect::FormTagHelper)
      ActionView::Helpers::FormBuilder.include(CountryOptionsSelect::FormBuilder)
    end

    CountryOptionsSelect.update_options_from_default
    CountryOptionsSelect.update_options_from_custom
  end
end