class UsersController < ApplicationController
  def show
    user = User.find_by(id: params[:id])
    render json: user.errors.details, status: :bad_request and return unless user != nil
    render json: user
  end

  def create
    puts("I AM HERE")
    user = User.new(user_params)

    new_params = { 'identification': params[:username], 'password': params[:password] }

    if user.save && user.create_login(new_params)
      head 200
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end