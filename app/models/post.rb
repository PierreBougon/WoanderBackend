class Post < ApplicationRecord
  has_many :post_likes
  belongs_to :user

  validates_presence_of :user_id, :media_type, :content, :description, :coordinates
end