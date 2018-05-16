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
    render json: { 'error': 'missing content' }, status: :bad_request and return unless post_params[:content] != nil
    render json: { 'error': 'wrong coordinates' }, status: :bad_request and return unless valid_coordinates(params[:coordinates]) != nil

    post = find_user(current_login).posts.create(post_params.except(:content))

    render json: { 'error': 'missing parameter' }, status: :bad_request and return unless post.save

    content = post_params[:content]
    # do something with content here

    render json: post, status: :created
  end

  def update
    render json: @post.errors.details, status: :bad_request and return unless @post.update(post_params)
    render json: @post, status: :created
  end

  private
  def valid_coordinates(coordinates)
    return nil if coordinates.nil? || coordinates.empty?

    if coordinates.count(':') != 1
      return nil
    end

    numbers = coordinates.split(':')

    begin
      numbers = numbers.map { |n| Float n }
    rescue StandardError
      return nil
    end
    numbers

  end
  
  def find_user(login)
    User.find_by(id: login.user_id)
  end

  def post_params
    params.permit(:media_type, :description, :coordinates, :content)
  end

  def find_post
    @post = Post.find_by(id: params[:id])
    render json: {}, status: :not_found and return unless @post
  end
end