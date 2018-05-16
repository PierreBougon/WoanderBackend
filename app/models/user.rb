class User < ApplicationRecord
  has_many :posts
  has_one :login
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username
end