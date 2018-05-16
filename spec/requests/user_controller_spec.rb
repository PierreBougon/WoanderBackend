require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:version) { '' }

  describe 'GET /users/:id' do
    let(:created_user) {
      FactoryBot.create :user
    }

    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/users/toto"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      context 'when params are incorrect' do
        it 'is not found' do
          get "#{version}/users/toto", headers: authentication_header
          expect(response).to have_http_status :not_found
        end
      end

      context 'when everything is fine' do
        it 'works' do
          FactoryBot.create_list :post, 10, user_id: created_user.id
          get "#{version}/users/#{created_user.id}", headers: authentication_header
          expect(response).to be_successful
          expect(parsed_body).to include 'username'
          expect(parsed_body['username']).to eq created_user.username
          expect(parsed_body).to include 'email'
          expect(parsed_body['email']).to eq created_user.email
          expect(parsed_body).to include 'posts'
          expect(parsed_body['posts'].count).to eq created_user.posts.count
        end
      end
    end
  end

  describe 'POST /users' do
    context 'when params are incorrect' do
      it 'is missing its body' do
        post "#{version}/users"
        expect(response).to have_http_status :bad_request
      end

      it 'is already an existing user' do
        created_user = FactoryBot.create :user
        params = { username: created_user.username, email: 'test@email.com', password: '123' }

        post "#{version}/users", params: params
        expect(response).to have_http_status :bad_request
      end

      it 'is an existing email' do
        created_user = FactoryBot.create :user
        params = { username: 'marc' , email: created_user.email, password: '123' }

        post "#{version}/users", params: params
        expect(response).to have_http_status :bad_request
      end
    end

    context 'when everything is fine' do
      let(:params) {
        { username: 'newUser', email: 'newUser@email', password: '123' }
      }

      it 'works and returns a token' do
        post "#{version}/users", params: params
        expect(response).to be_successful
        expect(parsed_body).to include 'access_token'
        user = User.last
        expect(parsed_body['access_token']).to eq user.login.oauth2_token
      end

      it 'creates a new user' do
        FactoryBot.create_list :user, 10
        expect {
          post "#{version}/users", params: params
        }.to change {
          User.all.count
        }.by 1
      end

      it 'creates a new login' do
        FactoryBot.create_list :user, 10
        expect {
          post "#{version}/users", params: params
        }.to change {
          Login.all.count
        }.by 1
      end
    end
  end
end