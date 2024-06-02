# frozen_string_literal: true

require 'action_view'

class FormTagHelperTest < ActionView::TestCase
  tests ActionView::Helpers::FormTagHelper

  def setup
    super
    @custom_country_options = {"BA"=>{"name"=>"Bosnia and Herzegovina", "dial_code"=>"+387", "currency"=>"BAM", "capital"=>"Sarajevo"},
                               "UY"=>{"name"=>"Uruguay", "dial_code"=>"+598", "currency"=>"UYU", "capital"=>"Montevideo"},
                               "AM"=>{"name"=>"Armenia", "dial_code"=>"+374", "currency"=>"AMD", "capital"=>"Yerevan"},
                               "KH"=>{"name"=>"Cambodia", "dial_code"=>"+855", "currency"=>"KHR", "capital"=>"Phnom Penh"},
                               "HT"=>{"name"=>"Haiti", "dial_code"=>"+509", "currency"=>"HTG", "capital"=>"Port-au-Prince"},
                               "AT"=>{"name"=>"Austria", "dial_code"=>"+43", "currency"=>"EUR", "capital"=>"Vienna"},
                               "CZ"=>{"name"=>"Czech Republic", "dial_code"=>"+420", "currency"=>"CZK", "capital"=>"Prague"},
                               "EG"=>{"name"=>"Egypt", "dial_code"=>"+20", "currency"=>"EGP", "capital"=>"Cairo"},
                               "BH"=>{"name"=>"Bahrain", "dial_code"=>"+973", "currency"=>"BHD", "capital"=>"Manama"},
                               "MS"=>{"name"=>"Montserrat", "dial_code"=>"+1664", "currency"=>"XCD", "capital"=>"Plymouth"}}
  end

  def test_currency_select_tag
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options
    expected = %(<select name="currency_test" id="currency_test"><option value="AMD">AMD (Armenia)</option>\n<option value="EUR">EUR (Austria)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="BAM">BAM (Bosnia and Herzegovina)</option>\n<option value="KHR">KHR (Cambodia)</option>\n<option value="CZK">CZK (Czech Republic)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option value="HTG">HTG (Haiti)</option>\n<option value="XCD">XCD (Montserrat)</option>\n<option value="UYU">UYU (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_text_format
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, text_format: '%{iso_code} - %{currency} - %{name}'
    expected = %(<select name="currency_test" id="currency_test"><option value="AMD">AM - AMD - Armenia</option>\n<option value="EUR">AT - EUR - Austria</option>\n<option value="BHD">BH - BHD - Bahrain</option>\n<option value="BAM">BA - BAM - Bosnia and Herzegovina</option>\n<option value="KHR">KH - KHR - Cambodia</option>\n<option value="CZK">CZ - CZK - Czech Republic</option>\n<option value="EGP">EG - EGP - Egypt</option>\n<option value="HTG">HT - HTG - Haiti</option>\n<option value="XCD">MS - XCD - Montserrat</option>\n<option value="UYU">UY - UYU - Uruguay</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_order_by_currency
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, order: [[:currency, :desc]]
    expected = %(<select name="currency_test" id="currency_test"><option value="XCD">XCD (Montserrat)</option>\n<option value="UYU">UYU (Uruguay)</option>\n<option value="KHR">KHR (Cambodia)</option>\n<option value="HTG">HTG (Haiti)</option>\n<option value="EUR">EUR (Austria)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option value="CZK">CZK (Czech Republic)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="BAM">BAM (Bosnia and Herzegovina)</option>\n<option value="AMD">AMD (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_updates
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, updates: {am: {currency: 'amd'}, 'ZZ' => {name: 'New country', currency: 'ZZZ'}}
    expected = %(<select name="currency_test" id="currency_test"><option value="amd">amd (Armenia)</option>\n<option value="EUR">EUR (Austria)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="BAM">BAM (Bosnia and Herzegovina)</option>\n<option value="KHR">KHR (Cambodia)</option>\n<option value="CZK">CZK (Czech Republic)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option value="HTG">HTG (Haiti)</option>\n<option value="XCD">XCD (Montserrat)</option>\n<option value="ZZZ">ZZZ (New country)</option>\n<option value="UYU">UYU (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_removals
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, removals: [:ba, 'UY', :At]
    expected = %(<select name="currency_test" id="currency_test"><option value="AMD">AMD (Armenia)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="KHR">KHR (Cambodia)</option>\n<option value="CZK">CZK (Czech Republic)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option value="HTG">HTG (Haiti)</option>\n<option value="XCD">XCD (Montserrat)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_html_attributes
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, html_attributes: {cZ: {test_attr: 'test-value'}}
    expected = %(<select name="currency_test" id="currency_test"><option value="AMD">AMD (Armenia)</option>\n<option value="EUR">EUR (Austria)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="BAM">BAM (Bosnia and Herzegovina)</option>\n<option value="KHR">KHR (Cambodia)</option>\n<option test_attr="test-value" value="CZK">CZK (Czech Republic)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option value="HTG">HTG (Haiti)</option>\n<option value="XCD">XCD (Montserrat)</option>\n<option value="UYU">UYU (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_currency_select_tag_selected_disabled
    actual = country_currency_select_tag :currency_test, options_override: @custom_country_options, selected: 'KHR', disabled: ['HTG', 'CZK']
    expected = %(<select name="currency_test" id="currency_test"><option value="AMD">AMD (Armenia)</option>\n<option value="EUR">EUR (Austria)</option>\n<option value="BHD">BHD (Bahrain)</option>\n<option value="BAM">BAM (Bosnia and Herzegovina)</option>\n<option selected="selected" value="KHR">KHR (Cambodia)</option>\n<option disabled="disabled" value="CZK">CZK (Czech Republic)</option>\n<option value="EGP">EGP (Egypt)</option>\n<option disabled="disabled" value="HTG">HTG (Haiti)</option>\n<option value="XCD">XCD (Montserrat)</option>\n<option value="UYU">UYU (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+374">+374 (Armenia)</option>\n<option value="+43">+43 (Austria)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+387">+387 (Bosnia and Herzegovina)</option>\n<option value="+855">+855 (Cambodia)</option>\n<option value="+420">+420 (Czech Republic)</option>\n<option value="+20">+20 (Egypt)</option>\n<option value="+509">+509 (Haiti)</option>\n<option value="+1664">+1664 (Montserrat)</option>\n<option value="+598">+598 (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_text_format
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, text_format: '%{iso_code} - %{dial_code} - %{name}'
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+374">AM - +374 - Armenia</option>\n<option value="+43">AT - +43 - Austria</option>\n<option value="+973">BH - +973 - Bahrain</option>\n<option value="+387">BA - +387 - Bosnia and Herzegovina</option>\n<option value="+855">KH - +855 - Cambodia</option>\n<option value="+420">CZ - +420 - Czech Republic</option>\n<option value="+20">EG - +20 - Egypt</option>\n<option value="+509">HT - +509 - Haiti</option>\n<option value="+1664">MS - +1664 - Montserrat</option>\n<option value="+598">UY - +598 - Uruguay</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_order_by_dial_code
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, order: [[:dial_code, :desc]]
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+1664">+1664 (Montserrat)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+855">+855 (Cambodia)</option>\n<option value="+598">+598 (Uruguay)</option>\n<option value="+509">+509 (Haiti)</option>\n<option value="+420">+420 (Czech Republic)</option>\n<option value="+387">+387 (Bosnia and Herzegovina)</option>\n<option value="+374">+374 (Armenia)</option>\n<option value="+43">+43 (Austria)</option>\n<option value="+20">+20 (Egypt)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_updates
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, updates: {am: {dial_code: '374'}, 'ZZ' => {name: 'New country', dial_code: '7365'}}
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="374">374 (Armenia)</option>\n<option value="+43">+43 (Austria)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+387">+387 (Bosnia and Herzegovina)</option>\n<option value="+855">+855 (Cambodia)</option>\n<option value="+420">+420 (Czech Republic)</option>\n<option value="+20">+20 (Egypt)</option>\n<option value="+509">+509 (Haiti)</option>\n<option value="+1664">+1664 (Montserrat)</option>\n<option value="7365">7365 (New country)</option>\n<option value="+598">+598 (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_removals
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, removals: [:ba, 'UY', :At]
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+374">+374 (Armenia)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+855">+855 (Cambodia)</option>\n<option value="+420">+420 (Czech Republic)</option>\n<option value="+20">+20 (Egypt)</option>\n<option value="+509">+509 (Haiti)</option>\n<option value="+1664">+1664 (Montserrat)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_html_attributes
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, html_attributes: {cZ: {test_attr: 'test-value'}}
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+374">+374 (Armenia)</option>\n<option value="+43">+43 (Austria)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+387">+387 (Bosnia and Herzegovina)</option>\n<option value="+855">+855 (Cambodia)</option>\n<option test_attr="test-value" value="+420">+420 (Czech Republic)</option>\n<option value="+20">+20 (Egypt)</option>\n<option value="+509">+509 (Haiti)</option>\n<option value="+1664">+1664 (Montserrat)</option>\n<option value="+598">+598 (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_dial_code_select_tag_selected_disabled
    actual = country_dial_code_select_tag :dial_code_test, options_override: @custom_country_options, selected: '+855', disabled: ['+509', '+420']
    expected = %(<select name="dial_code_test" id="dial_code_test"><option value="+374">+374 (Armenia)</option>\n<option value="+43">+43 (Austria)</option>\n<option value="+973">+973 (Bahrain)</option>\n<option value="+387">+387 (Bosnia and Herzegovina)</option>\n<option selected="selected" value="+855">+855 (Cambodia)</option>\n<option disabled="disabled" value="+420">+420 (Czech Republic)</option>\n<option value="+20">+20 (Egypt)</option>\n<option disabled="disabled" value="+509">+509 (Haiti)</option>\n<option value="+1664">+1664 (Montserrat)</option>\n<option value="+598">+598 (Uruguay)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">Cairo (Egypt)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Montevideo">Montevideo (Uruguay)</option>\n<option value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option value="Prague">Prague (Czech Republic)</option>\n<option value="Sarajevo">Sarajevo (Bosnia and Herzegovina)</option>\n<option value="Vienna">Vienna (Austria)</option>\n<option value="Yerevan">Yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_text_format
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, text_format: '%{iso_code} - %{capital} - %{name}'
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">EG - Cairo - Egypt</option>\n<option value="Manama">BH - Manama - Bahrain</option>\n<option value="Montevideo">UY - Montevideo - Uruguay</option>\n<option value="Phnom Penh">KH - Phnom Penh - Cambodia</option>\n<option value="Plymouth">MS - Plymouth - Montserrat</option>\n<option value="Port-au-Prince">HT - Port-au-Prince - Haiti</option>\n<option value="Prague">CZ - Prague - Czech Republic</option>\n<option value="Sarajevo">BA - Sarajevo - Bosnia and Herzegovina</option>\n<option value="Vienna">AT - Vienna - Austria</option>\n<option value="Yerevan">AM - Yerevan - Armenia</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_order_by_name
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, order: [[:name, :desc]]
    expected = %(<select name="capital_test" id="capital_test"><option value="Montevideo">Montevideo (Uruguay)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option value="Cairo">Cairo (Egypt)</option>\n<option value="Prague">Prague (Czech Republic)</option>\n<option value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Sarajevo">Sarajevo (Bosnia and Herzegovina)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Vienna">Vienna (Austria)</option>\n<option value="Yerevan">Yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_updates
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, updates: {am: {capital: 'yerevan'}, 'ZZ' => {name: 'New country', capital: 'New capital'}}
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">Cairo (Egypt)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Montevideo">Montevideo (Uruguay)</option>\n<option value="New capital">New capital (New country)</option>\n<option value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option value="Prague">Prague (Czech Republic)</option>\n<option value="Sarajevo">Sarajevo (Bosnia and Herzegovina)</option>\n<option value="Vienna">Vienna (Austria)</option>\n<option value="yerevan">yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_removals
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, removals: [:ba, 'UY', :At]
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">Cairo (Egypt)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option value="Prague">Prague (Czech Republic)</option>\n<option value="Yerevan">Yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_html_attributes
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, html_attributes: {cZ: {test_attr: 'test-value'}}
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">Cairo (Egypt)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Montevideo">Montevideo (Uruguay)</option>\n<option value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option test_attr="test-value" value="Prague">Prague (Czech Republic)</option>\n<option value="Sarajevo">Sarajevo (Bosnia and Herzegovina)</option>\n<option value="Vienna">Vienna (Austria)</option>\n<option value="Yerevan">Yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end

  def test_capital_select_tag_selected_disabled
    actual = country_capital_select_tag :capital_test, options_override: @custom_country_options, selected: 'Phnom Penh', disabled: ['Port-au-Prince', 'Prague']
    expected = %(<select name="capital_test" id="capital_test"><option value="Cairo">Cairo (Egypt)</option>\n<option value="Manama">Manama (Bahrain)</option>\n<option value="Montevideo">Montevideo (Uruguay)</option>\n<option selected="selected" value="Phnom Penh">Phnom Penh (Cambodia)</option>\n<option value="Plymouth">Plymouth (Montserrat)</option>\n<option disabled="disabled" value="Port-au-Prince">Port-au-Prince (Haiti)</option>\n<option disabled="disabled" value="Prague">Prague (Czech Republic)</option>\n<option value="Sarajevo">Sarajevo (Bosnia and Herzegovina)</option>\n<option value="Vienna">Vienna (Austria)</option>\n<option value="Yerevan">Yerevan (Armenia)</option></select>)

    assert_dom_equal expected, actual
  end
end