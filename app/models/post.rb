class Post < ApplicationRecord
  has_many :post_likes
  belongs_to :user

  validates_presence_of :user_id, :media_type, :media_link, :description, :coordinates

  def initialize(params)
    super
    write_attribute(:created_at, Time.now)
    write_attribute(:media_link, 'http://localhost/files/sdfsfa')
  end
end