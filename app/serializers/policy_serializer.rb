class PolicySerializer < BaseSerializer
  attributes :id, :expiration, :bucket, :key, :acl, :content_type, :content_length_minimum, :content_length_maximum, :signature

  belongs_to :user
end
