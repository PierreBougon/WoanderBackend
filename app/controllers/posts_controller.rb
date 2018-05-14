class PostsController < ApplicationController
  before_action :authenticate!
  before_action :find_post, only: [:show, :update]

  def show
    render json: @post
  end

  def index
    render json: Post.all
  end

  def create
    post = current_login.user.posts.create(post_params)
    render json: post.errors.details, status: :bad_request and return unless post.save
    render json: post, status: :created
  end

  def update
    render json: @post.errors.details, status: :bad_request and return unless @post.update(post_params)
    render json: @post, status: :created
  end

  private

  def post_params
    params.require(:post).permit(:media_type, :description, :coordinates, :content)
  end

  def find_post
    @post = Post.find_by(id: params['id'])
    render json: {}, status: :not_found and return unless @post
  end
end