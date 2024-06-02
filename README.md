# Country Options Select

Provides 3 form select helpers for Dial Codes, Capital Cities and Currencies.
The data is retrieved from the CountriesNow API (https://countriesnow.space). This data can be viewed in the default_options.yml file in the lib directory.

## Installation

```
gem install country_options_select
```

## Usage

```
country_dial_code_select_tag :dial_code_field
country_capital_select_tag :capital_field
country_currency_select_tag :currency_field

form.country_dial_code_select :dial_code_field
form.country_capital_select :capital_field
form.country_currency_select :currency_field
```

There are custom arguments that can be passed to these selects:

**text_format** - Displayed text format of each dropdown option, options are `currency`, `dial_code`, `capital`, `iso_code` and `name`:
```
text_format: '%{iso_code} - Country name: %{name}, Currency: %{currency}'
```

**order** - Array for sorting by particular fields, options are `currency`, `dial_code`, `capital`, `iso_code` and `name`, default is `asc`, and `desc` can be added to each option:
```
order: [:currency, [:dial_code, :desc], :name]
```
(Default ordering is `name: :asc`, except for capital_select which is `capital: :asc`)

**updates** - Hash of `{ISO code => {select type => select type value}}` for options to be added or updated (meant for making updates to individual selects, to make application-wide updates use `CountryOptionsSelect.update_options`, explained in the custom options section):
```
updates: {gb: {name: 'UK'}, zz: {name: 'New country', currency: 'ZZZ'}}
```

**removals** - Array of ISO codes for options to be removed (meant for removing countries from individual selects, to make application-wide removals use `CountryOptionsSelect.remove_options`, explained in the custom options section):
```
removals: [:gb, :au]
```

**html_attributes** - Add HTML attributes for specific dropdown options, include options either by ISO code or value:
```
html_attributes: {gb: {class: 'option'}, 'Tokyo' => {class: 'capital-option'}}
```

**selected/disabled** - Function the same as they do for `options_for_select`, can select or disable one or multiple options using an option's value:
```
selected: '+1684', disabled: ['+355', '+213']
```

**options_override** - Allows for complete override of options, ignoring any default or custom options:
```
options_override: {aa: {name: 'Lone country', dial_code: '+1234'}
```

Any other arguments passed will be treated as standard HTML attributes.

## Custom options

If the default options require changes, there are a few customization options available:

### Update custom options file

To hard code changes to the default options, you can add a `country_options_select.yml` file to the config directory of your app, and add overrides with keys in the same format as they are in the `default_options.yml` file. In order to remove a country or a select type for a country, add the relevant key but leave its value blank.

There are methods to add/update the `country_options_select.yml` file:

**update_options** - Accepts hash of `{ISO code => {select type => select type value}}`, any keys that don't exist will be added as new options:
```
options = {gb: {name: 'UK'}, zz: {name: 'New country', currency: 'ZZZ'}}
CountryOptionsSelect.update_options(options)
```

`country_options_select.yml` file produced:
```
GB:
  name: UK
ZZ:
  name: New country
  currency: ZZZ
```

**remove_options** - Accepts array of either ISO codes of countries to be removed, or `{ISO code => [select types]}`, for select types of specific countries to be removed:
```
options = [:af, :al, dz: [:dial_code, :capital], as: [:currency], ad: [:capital]]
CountryOptionsSelect.remove_options(options)
```

`country_options_select.yml` file produced:
```
AF:
AL:
DZ:
  dial_code:
  capital:
AS:
  currency:
AD:
  capital:
```

**update_options_from_api** - If there are any updates to the data from the API, you can run:
```
CountryOptionsSelect.update_options_from_api
```
To add these updates to `country_options_select.yml`. Note that existing custom options will override any incoming API changes.

# Individual form select customization

As explained previously the `updates`, `removals` and `options_override` arguments can be added to a specific form select to update its options, if that is required. These will override any existing custom options added to the `country_options_select.yml` file.

# I18n translations

You can also add I18n translations for options in a dictionary file under a `country_options_select` key. These should have the same tree structure as `default_options.yml`:
```
country_options_select:
  gb:
    name: UK
    currency: Pound
```

## License

[MIT License](./MIT-LICENSE)