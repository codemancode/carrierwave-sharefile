# Carrierwave::Sharefile

This gem adds support for [sharefile](https://sharefile.com) to the CarrierWave.

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-sharefile'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-sharefile

## Usage

You'll need to add a configuration block in your ```
config/initializers/carrierwave.rb ``` file.

```ruby
CarrierWave.configure do |config|
  config.sharefile_client_id = ''
  config.sharefile_client_secret = ''
  config.sharefile_username = ''
  config.sharefile_password = ''
end
```

In your uploader add sharefile as the storage option:

```ruby
class DocumentUploader < CarrierWave::Uploader::Base
  storage :sharefile
end
```

## Contributing

1. Fork it ( https://github.com/codemancode/carrierwave-sharefile/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
