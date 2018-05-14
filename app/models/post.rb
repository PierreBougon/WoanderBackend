class Post < ApplicationRecord
  has_many :post_likes

  validates_presence_of :user_id, :media_type, :media_link, :description, :coordinates
end