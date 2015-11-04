class UserSerializer < BaseSerializer
  attributes :username

  has_many :scores
end
