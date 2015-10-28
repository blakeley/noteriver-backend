class UserSerializer < BaseSerializer
  attributes :id

  has_many :scores
end
