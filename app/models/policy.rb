require 'base64'
require 'openssl'
require 'digest/sha1'

class Policy
  attr_accessor :expiration_time, :bucket, :key, :acl, :content_type, :content_length_minimum, :content_length_maximum

  def self.find(id)
    Policy.new(id: id)
  end

  def initialize(opts = {})
    opts.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def id=(id)
    self.document = JSON.parse(Base64.decode64(id))
  end

  def id
    Base64.strict_encode64(document.to_json).strip
  end

  def document=(document)
    self.expiration_time = Time.parse(document["expiration"])
    self.bucket = document["conditions"][0]["bucket"]
    self.key = document["conditions"][1]["key"]
    self.acl = document["conditions"][2]["acl"]
    self.content_type = document["conditions"][3]["Content-Type"]
    self.content_length_minimum = document["conditions"][4][1].to_i
    self.content_length_maximum = document["conditions"][4][2].to_i
  end

  def document
    {
      "expiration" => expiration,
      "conditions" => [
        {"bucket" => bucket},
        {"key" => key},
        {"acl" => acl},
        {"Content-Type" => content_type},
        ["content-length-range", content_length_minimum, content_length_maximum],
      ],
    }
  end

  def content_length=(content_length)
    self.content_length_minimum = content_length
    self.content_length_maximum = content_length
  end

  def expiration
    expiration_time.to_time.iso8601
  end

  def user_id
    key.split('/')[1].to_i
  end

  def valid?
    expiration_time < Time.now + 1.hour &&
    acl == "public-read" &&
    content_type == "audio/midi" &&
    content_length_minimum > 0 &&
    content_length_minimum == content_length_maximum &&
    content_length_maximum < 5.megabytes
  end

  def signature
    Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'), 
        ENV["NOTERIVER_AWS_SECRET_ACCESS_KEY"], id
      )
    )
  end


end
