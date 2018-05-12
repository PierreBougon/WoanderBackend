class Comment < ApplicationRecord
  has_many :comment_likes
end