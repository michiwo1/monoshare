CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAW2OCUS3YZNGMMRU5',
    aws_secret_access_key: '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',
    region: 'ap-northeast-1'
  }
  config.fog_public = false 
  config.fog_directory  = 'monoshare-photo'
  config.cache_storage = :fog
end
