class ScoreSerializer < ActiveModel::Serializer
  attributes :id, :title, :artist, :user_id, :s3_key

end
