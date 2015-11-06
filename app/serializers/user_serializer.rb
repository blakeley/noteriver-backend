class UserSerializer < BaseSerializer
  attributes :username, :email_md5

  has_many :scores
end
