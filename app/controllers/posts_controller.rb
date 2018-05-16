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
    content = post_params[:content]
    # do something with content here
    post = find_user(current_login).posts.create(post_params.except(:content))

    render json: post.errors.details, status: :bad_request and return unless post.save
    render json: post, status: :created
  end

  def update
    render json: @post.errors.details, status: :bad_request and return unless @post.update(post_params)
    render json: @post, status: :created
  end

  private

  def find_user(login)
    User.find_by(id: login.user_id)
  end

  def post_params
    params.permit(:media_type, :description, :coordinates, :content)
  end

  def find_post
    @post = Post.find_by(id: params['id'])
    render json: {}, status: :not_found and return unless @post
  end
end