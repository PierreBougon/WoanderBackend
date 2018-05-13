class Comment < ApplicationRecord
  has_many :comment_likes
  belongs_to :user
  belongs_to :post

  validates_presence_of :user_id, :post_id, :content
end