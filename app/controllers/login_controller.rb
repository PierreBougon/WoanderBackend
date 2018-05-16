class LoginController < ApplicationController
  before_action :authenticate!

  def login
    render json: { response: 'logged' }
  end
end