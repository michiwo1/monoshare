class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
   process resize_to_fit: [800, 800]
  end

  version :thumb50 do
    process resize_to_fit: [350, 350]
  end

  version :thumbindex do
    process resize_to_fit: [220, 400]
  end

  

  if Rails.env.development?
    CarrierWave.configure do |config|
     config.cache_storage = :file
    end
  elsif Rails.env.test?
    CarrierWave.configure do |config|

      config.cache_storage = :fog
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
    %w(jpg jpeg gif png)
  end

  def filename
    original_filename if original_filename
  end

end
