class ApplicationController < ActionController::Base

  def moip_v2_api
    auth = Moip2::Auth::Basic.new(ENV['MOIP_API_TOKEN'], ENV['MOIP_API_KEY'])
    client = Moip2::Client.new(:production, auth)
    Moip2::Api.new(client)
  end

end
