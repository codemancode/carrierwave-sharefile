require 'carrierwave'
require 'carrierwave/sharefile/client'
require 'carrierwave/storage/sharefile'
require "carrierwave/sharefile/version"

class CarrierWave::Uploader::Base
  add_config :sharefile_api_key
  add_config :sharefile_vault_id
  add_config :sharefile_attributes

  configure do |config|
    config.storage_engines[:sharefile] = 'CarrierWave::Storage::Sharefile'
  end
end
