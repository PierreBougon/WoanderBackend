# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:version) { '' }

  describe 'GET /posts' do
    let(:created_user) do
      FactoryBot.create :user
    end

    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/posts"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      it 'returns the correct number of posts' do
        FactoryBot.create_list :post, 10, user_id: created_user.id

        get "#{version}/posts", headers: authentication_header
        expect(response).to be_successful
        expect(parsed_body.count).to eq 10
      end
    end
  end

  describe 'GET /posts/:id' do
    let(:created_user) do
      FactoryBot.create :user
    end

    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/posts/toto"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      context 'when params are incorrect' do
        it 'is not found' do
          get "#{version}/posts/toto", headers: authentication_header
          expect(response).to have_http_status :not_found
        end
      end

      context 'when everything is fine' do
        it 'returns the good post' do
          FactoryBot.create_list :post, 10, user_id: created_user.id
          post = created_user.posts[8]

          get "#{version}/posts/#{post.id}", headers: authentication_header
          expect(response).to be_successful
          expect(parsed_body).to include 'media_type'
          expect(parsed_body['media_type']).to eq post.media_type
          expect(parsed_body).to include 'content'
          expect(parsed_body['content']).to eq post.content
          expect(parsed_body).to include 'description'
          expect(parsed_body['description']).to eq post.description
          expect(parsed_body).to include 'user'
          expect(parsed_body['user']['username']).to eq created_user.username
        end
      end
    end
  end

  describe 'POST /posts' do
    let(:created_post) do
      FactoryBot.create :post, user_id: current_login.user_id
    end

    context 'when unauthenticated' do
      it 'is unauthorized' do
        post "#{version}/posts"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:params) do
        {
            media_type: Faker::Lorem.word,
            description: Faker::Lorem.paragraph,
            coordinates: "#{Faker::Address.latitude}:#{Faker::Address.longitude}",
            content: Faker::Lorem.paragraph
        }
      end

      context 'when params are incorrect' do
        it 'is missing media type' do
          params.delete(:media_type)
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'missing parameter'
        end

        it 'is missing content' do
          params.delete(:content)
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'missing content'
        end

        it 'is missing description' do
          params.delete(:description)
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'missing parameter'
        end

        it 'is missing coordinates' do
          params.delete(:coordinates)
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'wrong coordinates'
        end

        it 'has wrong coordinates' do
          params[:coordinates] = 'sadfsafsadfasdfasdfaf'
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'wrong coordinates'
        end

        it 'has wrong coordinates II' do
          params[:coordinates] = 'sadfsafsad:fasdfasdfaf'
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'wrong coordinates'
        end

        it 'has wrong coordinates World' do
          params[:coordinates] = '-123213123123:fasdfasdfaf'
          post "#{version}/posts", headers: authentication_header, params: params
          expect(response).to have_http_status :bad_request
          expect(parsed_body).to include 'error'
          expect(parsed_body['error']).to eq 'wrong coordinates'
        end
      end

      context 'when everything is fine' do
        it 'works' do
          post "#{version}/posts", headers: authentication_header, params: params

          post = Post.last

          expect(response).to be_successful

          expect(post.media_type).to eq params[:media_type]
          expect(parsed_body).to include 'media_type'
          expect(parsed_body['media_type']).to eq post.media_type

          expect(parsed_body).to include 'content'
          expect(parsed_body['content']).to eq post.content

          expect(post.description).to eq params[:description]
          expect(parsed_body).to include 'description'
          expect(parsed_body['description']).to eq post.description

          expect(post.user.username).to eq current_user.username
          expect(parsed_body).to include 'user'
          expect(parsed_body['user']['username']).to eq current_user.username
        end

        it 'creates a new post' do
          usr = FactoryBot.create :user
          FactoryBot.create_list :post, 10, user_id: usr.id
          expect do
            post "#{version}/posts", headers: authentication_header, params: params
          end.to change {
            Post.all.count
          }.by 1
        end
      end
    end
  end

  describe 'GET /posts/coordinates' do

    context 'when unauthenticated' do
      it 'is unauthorized' do
        get "#{version}/posts/coordinates"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
      let(:created_user) do
        FactoryBot.create :user
      end

      before do
        FactoryBot.create_list :post, 10, user_id: created_user.id
        get "#{version}/posts/coordinates", headers: authentication_header
      end

      it 'returns the correct number of posts' do
        expect(response).to be_successful
        expect(parsed_body.count).to eq 10
      end

      it 'returns minified and correct posts' do
        expect(response).to be_successful
        expect(parsed_body.count).to eq 10
        parsed_body.each do |post|
          expect(post.keys).to eq %w[id media_type coordinates]
          postBase = Post.find_by(id: post['id'])
          expect(post.values).to eq [postBase.id, postBase.media_type, postBase.coordinates]
        end
      end
    end
  end
end
