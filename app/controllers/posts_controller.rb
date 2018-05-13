class PostsController < ApplicationController
  before_action :authenticate!
  before_action :find_post, only: [:show]

  def show
    render json: @post
  end

  def index
    params[:page] = 1 if params[:page].nil?
    params[:per_page] = 5 if params[:per_page].nil?
    paginate json: Post.all, status: :partial_content
  end

  def find_post
    @post = Post.find_by(id: params['id'])
    render json: {}, status: :not_found and return unless @post
  end
end