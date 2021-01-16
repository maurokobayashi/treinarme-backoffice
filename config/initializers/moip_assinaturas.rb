Moip::Assinaturas.config do |config|
  config.sandbox    = false
  config.token      = ENV['MOIP_API_TOKEN']
  config.key        = ENV['MOIP_API_KEY']
  config.http_debug = true
end