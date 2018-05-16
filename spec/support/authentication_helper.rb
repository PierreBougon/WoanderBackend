module AuthenticationHelper
  def current_user
    @user ||= FactoryBot.create :user
  end

  def authentication_header
    {
      'Authorization': "Bearer #{current_user.login.oauth2_token}"
    }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end