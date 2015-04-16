class Score < ActiveRecord::Base
  validates :title, presence: true
  validates :artist, presence: true
  belongs_to :user

end
