class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env

  # load secured settings
  begin
    hash = YAML.load(ERB.new(File.read("#{Rails.root}/config/secured_settings.yml")).result)[Rails.env]
    instance.deep_merge!(hash)
  rescue => e
  end

  load!
end