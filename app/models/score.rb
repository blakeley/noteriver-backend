class Score < ActiveRecord::Base
  validates :title, presence: true
  validates :artist, presence: true
  validates :s3_key, presence: true
  belongs_to :user

end
