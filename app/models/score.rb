class Score < ActiveRecord::Base
  validates :title, presence: true
  validates :artist, presence: true
  validates :s3_key, presence: true
  belongs_to :user

  def self.artist_matches(query)
    Score.arel_table[:artist].matches("%#{query}%")
  end

  def self.title_matches(query)
    Score.arel_table[:title].matches("%#{query}%")
  end

  def self.search(query)
    where (title_matches query).or(artist_matches query)
  end
end
