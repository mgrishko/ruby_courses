CarrierWave.configure do |config|
  # In production, use S3
  # In development, use filesystem and processing
  # In testing, use filesystem and no processing

  # To use S3 CNAME, set bucket name to the CNAME:
  #   photos.example.com
  # Set s3_cnamed to true.
  # Set CNAME on your DNS:
  #   cdn.example.com => cdn.example.com.s3.amazonaws.com

  config.root = Rails.root.join('public')

  if %w(production staging qa).include?(Rails.env)
    # config.storage = :s3
    # config.s3_access_key_id = 'YOUR_S3_ACCESS_KEY'
    # config.s3_secret_access_key = 'YOUR_S3_SECRET_ACCESS_KEY'
    # config.s3_bucket = 'BUCKET_NAME'
    # config.s3_cnamed = true

    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => Settings.rackspace.username,
      :rackspace_api_key  => Settings.rackspace.api_key
    }
    config.fog_directory = Rails.env
    config.storage = :fog
    config.fog_host = Settings.rackspace.fog_host

  #elsif Rails.env.development?
  #  config.storage = :file

  elsif Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false

  else
    config.storage = :file
  end
end
