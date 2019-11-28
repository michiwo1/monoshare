class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
   process resize_to_fit: [200, 200]
  end

  version :thumb50 do
    process resize_to_fit: [350, 350]
  end

  if Rails.env.development?
    CarrierWave.configure do |config|
     config.cache_storage = :file
    end
  elsif Rails.env.test?
    CarrierWave.configure do |config|

      config.cache_storage = :file
    end
  else
    CarrierWave.configure do |config|

      config.cache_storage = :fog
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(png jpg)
  end

  def filename
    original_filename if original_filename
  end

end
