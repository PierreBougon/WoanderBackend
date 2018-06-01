class User < ApplicationRecord
  has_many :posts
  has_one :login
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  def reset_password!(password)
    self.login.password_digest = password
    save!
  end
end