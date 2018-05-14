class UsersController < ApplicationController
  def create
    puts("I AM HERE")
    user = User.new(user_params)
    if user.save && user.create_login(login_params)
      head 200
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def login_params
    params.require(:auth).permit(:identification, :password, :password_confirmation)
  end
end