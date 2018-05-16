class UsersController < ApplicationController
  before_action :authenticate!, only: [:show]

  def show
    user = User.find_by(id: params[:id])
    render json: { "error": "Not found" }, status: :not_found and return unless user != nil
    render json: user
  end

  def create
    user = User.new(user_params)
    new_params = { 'identification': params[:username], 'password': params[:password] }
    if user.save && user.create_login(new_params)
      render json: { 'access_token': user.login.oauth2_token }, head: 200
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def user_params
    params.except(:password).permit(:username, :email)
  end
end