class UserSerializer < ActiveModel::Serializer
  attributes :id

  has_many :scores
end
