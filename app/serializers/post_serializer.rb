class PostSerializer < ActiveModel::Serializer
  attributes :id, :media_type, :media_link, :description, :coordinates, :created_at
  belongs_to :user
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end
end
