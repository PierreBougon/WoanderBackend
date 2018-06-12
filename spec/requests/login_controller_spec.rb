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

  describe 'GET /login/onetimetoken' do
    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/login/onetimetoken"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      before {
        get "#{version}/login/onetimetoken", headers: authentication_header
      }

      it 'is working' do
        expect(response).to be_successful
      end

      it 'returns the one time token' do
        expect(parsed_body).to include 'token'
        expect(parsed_body['token']).to eq current_user.login.single_use_oauth2_token
      end
    end
  end

  describe 'PUT /login/resetpassword' do
    let(:params) do { password: '123' } end

    context 'when unauthenticated' do
      it 'is unauthorized' do
        put "#{version}/login/resetpassword", params: params
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      it 'is missing content type' do
        put "#{version}/login/resetpassword", headers: authentication_header, params: params
        expect(response).to have_http_status :unauthorized
      end

      it 'correctly reset the password' do
        validHeader = authentication_header
        validHeader[:Authorization] = "Bearer #{current_user.login.single_use_oauth2_token}"
        put "#{version}/login/resetpassword", headers: validHeader, params: params
        expect(response).to be_successful
      end
    end
  end
end