# frozen_string_literal: true
  
class CountryOptionsSelect
  module FormOptionsHelper
    %w(currency dial_code capital).each do |select_type|
      define_method("country_#{select_type}_for_select") do |**args|
        country_options_for_select(select_type, **args)
      end

      define_method("country_#{select_type}_select") do |object, method, options = {}, html_options = {}|
        country_options_select(select_type, object, method, options, html_options)
      end
    end

    private
      def country_options_for_select(select_type, selected: nil, disabled: nil, text_format: nil, updates: nil,
                                     removals: nil, options_override: nil, order: nil, html_attributes: {})
        country_options = (CountryOptionsSelect.transform_updates(options_override) || CountryOptionsSelect.country_options).deep_dup

        country_options.deep_merge!(CountryOptionsSelect.transform_updates(**I18n.t('country_options_select'))) if I18n.exists?('country_options_select')
        country_options.deep_merge!(CountryOptionsSelect.transform_updates(**updates)) if updates
        country_options.except!(*removals.map{|iso_code| iso_code.to_s.upcase}) if removals

        options = country_options.to_a.select{|_, options| options[select_type]}.tap do |country_options|
          if order
            order = order.dup
            order = Array.wrap(order).map{|_order| Array === _order ? [_order[0].to_s.downcase, _order[1]] : [_order.to_s.downcase, :asc]}
            country_options.sort! do |options1, options2|
              comp = 0
              order.each do |ordering|
                break if !comp.zero?
                comp1, comp2 = (ordering[0] == 'iso_code') ? [options1[0], options2[0]] : [options1[1][ordering[0]], options2[1][ordering[0]]]
                comp1, comp2 = comp1.to_s.downcase, comp2.to_s.downcase
                comp1, comp2 = comp1.to_i, comp2.to_i if ordering[0] == 'dial_code'
                comp = (comp1 <=> comp2) || 0
                comp *= -1 if ordering[1].to_sym.downcase == :desc
              end
              comp
            end
          else
            order_type = select_type == 'capital' ? 'capital' : 'name'
            country_options.sort_by!{|_, options| options[order_type].to_s.downcase}
          end
        end.map do |element|
          text = if text_format.present?
                   text_format % {dial_code: element.last['dial_code'],
                                  capital: element.last['capital'],
                                  currency: element.last['currency'],
                                  name: element.last['name'],
                                  iso_code: element.first}
                 else
                   "#{element.last[select_type]} (#{element.last['name']})"
                 end

          [text, element.last[select_type],
           html_attributes[element.last[select_type]] || html_attributes.transform_keys{|iso_code| iso_code.to_s.upcase}[element.first] || {}]
        end

        options_for_select(options, selected: selected, disabled: disabled)
      end

      def country_options_select(select_type, object, method, options, html_options)
        CountryOptionsSelect::CountryOptionsSelectTag.new(select_type, object, method, self, options, html_options).render
      end
    
      def custom_country_options_select
      end
  end

  module FormBuilder
    %w(currency dial_code capital).each do |select_type|
      define_method("country_#{select_type}_select") do |method, options = {}, html_options = {}|
        @template.send("country_#{select_type}_select", @object_name, method, objectify_options(options), @default_html_options.merge(html_options))
      end
    end
  end
end