class LoginController < ApplicationController
  before_action :authenticate!
  before_action :consume_single_use_oauth2_token, only: [:resetpassword]

  def login
    render json: { response: 'logged' }
  end

  def onetimetoken
    render json: { token: current_login.single_use_oauth2_token }
  end

  def resetpassword
    user = User.find_by(current_login.user_id)
    
    if user && user.reset_password!(params[:password])
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: user.errors.full_messages}, status: :unprocessable_entity
    end
  end
end