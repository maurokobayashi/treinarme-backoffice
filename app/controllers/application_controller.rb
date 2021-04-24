class ApplicationController < ActionController::Base

  before_action :require_authentication

  def moip_v2_api
    auth = Moip2::Auth::Basic.new(ENV['MOIP_API_TOKEN'], ENV['MOIP_API_KEY'])
    client = Moip2::Client.new(:production, auth)
    Moip2::Api.new(client)
  end

private
  def require_authentication
    if params[:secret] && params[:secret] == "rtg32oue"
      cookies[:backoffice_singed_in] = { value: "true", expires: 180.days.from_now }
    else
      redirect_to "https://www.treinar.me" if cookies[:backoffice_singed_in].blank?
    end
  end

end
