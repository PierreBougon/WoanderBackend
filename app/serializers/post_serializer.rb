class PostSerializer < ActiveModel::Serializer
  attributes :id, :media_type, :media_link, :description, :created_at
  belongs_to :user
end
