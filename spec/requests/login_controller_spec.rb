require 'rails_helper'

RSpec.describe 'Login', type: :request do
  let(:version) { '' }

  describe 'GET /login' do
    context 'when missing token' do
      it 'is unauthorized' do
        get "#{version}/login"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when correct' do
      it 'is authenticated' do
        get "#{version}/login", headers: authentication_header
        expect(response).to be_successful
      end
    end
  end
end