require 'rails_helper'

RSpec.describe 'Login', type: :request do
  let(:version) { '' }

  describe 'GET /login' do
    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/login"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      it 'works' do
        get "#{version}/login", headers: authentication_header
        expect(response).to be_successful
      end
    end
  end
end