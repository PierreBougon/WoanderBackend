class PostSerializer < ActiveModel::Serializer
  attributes :id, :media_type, :content, :description, :coordinates, :created_at
  belongs_to :user
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end
end
