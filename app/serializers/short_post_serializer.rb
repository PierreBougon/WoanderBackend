class ShortPostSerializer < ActiveModel::Serializer
  attributes :id, :media_type, :coordinates
end