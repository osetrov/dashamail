require 'dashamail'

Dashamail.setup do |config|
  if File.exist?('config/dashamail.yml')
    processed = YAML.load_file('config/dashamail.yml')[Rails.env]

    processed.each do |k, v|
      config::register k.underscore.to_sym, v
    end

    config::Request.api_key = Dashamail::api_key || ENV['DASHAMAIL_API_KEY']
    config::Request.timeout = 15
    config::Request.open_timeout = 15
    config::Request.symbolize_keys = true
    config::Request.debug = false
  end
end