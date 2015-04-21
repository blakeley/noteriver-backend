class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: true
  has_secure_password
  has_many :sessions
  has_many :scores

end
