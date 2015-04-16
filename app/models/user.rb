class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, email: true
  has_secure_password
  has_many :sessions
  has_many :scores

end
