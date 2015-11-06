class User < ActiveRecord::Base
  before_validation :generate_username

  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}

  has_secure_password

  has_many :sessions
  has_many :scores

  def generate_username
    if self.username.blank?
      begin 
        self.username = SecureRandom.hex
      end while self.class.exists?(username: username)
    end
  end

  def email_md5
    Digest::MD5.hexdigest email
  end
end
