module AuthenticationHelper
  def current_user
    @user ||= FactoryBot.create :user
  end

  def authentication_header
    token = RailsApiAuth::new(payload: { sub: current_user.login }).token
    {
        'Authorization': "Bearer #{token}"
    }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end