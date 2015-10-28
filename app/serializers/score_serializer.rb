class ScoreSerializer < ActiveModel::Serializer
  attributes :id, :title, :artist, :s3_key, :created_at

  belongs_to :user
end
