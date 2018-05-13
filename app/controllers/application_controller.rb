class ApplicationController < ActionController::API
  include RailsApiAuth::Authentication

  def ping
    render json: { response: 'pong' }
  end
end
