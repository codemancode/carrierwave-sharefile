require 'carrierwave'
require 'carrierwave/sharefile/client'
require 'carrierwave/storage/sharefile'
require "carrierwave/sharefile/version"

class CarrierWave::Uploader::Base
  add_config :sharefile_client_id
  add_config :sharefile_client_secret
  add_config :sharefile_username
  add_config :sharefile_password
  add_config :sharefile_subdomain
  add_config :sharefile_root

  configure do |config|
    config.storage_engines[:sharefile] = 'CarrierWave::Storage::Sharefile'
  end
end
