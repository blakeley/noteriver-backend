require 'test_helper'
require 'action_dispatch/testing/test_process'


class PolicyTest < ActiveSupport::TestCase

  setup do
    @policy = Policy.new(
      "expiration" => (Time.now.utc + 1.hour).iso8601,
      "bucket" => "noteriver-dev",
      "key" => "uploads/7357/s3-test-file.mid",
      "acl" => "public-read",
      "content_type" => "audio/midi",
      "content_length" => 123.kilobytes,
      )
  end

  def test_constructor_sets_bucket
    bucket = "noteriver-dev"
    policy = Policy.new(bucket: bucket)
    assert_equal bucket, policy.bucket
  end

  def test_constructor_sets_key
    key = "uploads/1/s3-test-file.mid"
    policy = Policy.new(key: key)
    assert_equal key, policy.key
  end

  def test_constructor_sets_acl
    acl = "public-read"
    policy = Policy.new(acl: acl)
    assert_equal acl, policy.acl
  end

  def test_constructor_sets_content_type
    content_type = "audio/midi"
    policy = Policy.new(content_type: content_type)
    assert_equal content_type, policy.content_type
  end

  def test_constructor_sets_content_length_minimum
    content_length_minimum = 123.kilobytes
    policy = Policy.new(content_length_minimum: content_length_minimum)
    assert_equal content_length_minimum, policy.content_length_minimum
  end

  def test_constructor_sets_content_length_maximum
    content_length_maximum = 123.kilobytes
    policy = Policy.new(content_length_maximum: content_length_maximum)
    assert_equal content_length_maximum, policy.content_length_maximum
  end

  def test_constructor_sets_expiration
    expiration = (Time.now.utc + 1.hour).iso8601
    policy = Policy.new(expiration: expiration)
    assert_equal expiration, policy.expiration
  end

  def test_document_structure
    assert_equal @policy.expiration, @policy.document["expiration"]
    assert_equal @policy.bucket, @policy.document["conditions"][0]["bucket"]
    assert_equal @policy.key, @policy.document["conditions"][1]["key"]
    assert_equal @policy.acl, @policy.document["conditions"][2]["acl"]
    assert_equal @policy.content_type, @policy.document["conditions"][3]["Content-Type"]
    assert_equal @policy.content_length_minimum, @policy.document["conditions"][4][1]
    assert_equal @policy.content_length_maximum, @policy.document["conditions"][4][2]
  end

  def test_document_is_stable
    new_policy = Policy.new(document: @policy.document)
    assert_equal @policy.document, new_policy.document
  end

  def test_id_is_stable
    id = 'eyJleHBpcmF0aW9uIjoiMjAxNS0xMS0xMFQwMDo0NTo0MS40OTdaIiwiY29uZGl0aW9ucyI6W3siYnVja2V0Ijoibm90ZXJpdmVyIn0seyJrZXkiOiJ1cGxvYWRzLzEvYWxiX3NlMy5taWQifSx7ImFjbCI6InB1YmxpYy1yZWFkIn0seyJDb250ZW50LVR5cGUiOiJhdWRpby9taWRpIn0sWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMjg5MTUsMjg5MTVdXX0='
    policy = Policy.find(id)
    assert_equal id, policy.id
  end

  def test_user_id
    user_id = 7537
    policy = Policy.new(key: "uploads/#{user_id}/s3-test-file.mid")
    assert_equal user_id, policy.user_id
  end

  def test_valid
    assert @policy.valid?
  end

  def test_invalid_expiration
    @policy.expiration = (Time.now.utc + 61.minutes).iso8601
    refute @policy.valid?
  end

  def test_invalid_acl
    @policy.acl = "private"
    refute @policy.valid?
  end

  def test_invalid_content_type
    @policy.acl = "audio/mp3"
    refute @policy.valid?
  end

  def test_invalid_content_length_minimum
    @policy.content_length_minimum = 0
    refute @policy.valid?
  end

  def test_invalid_content_length_maximum
    @policy.content_length_maximum = 1.gigabyte
    refute @policy.valid?
  end

  def test_signature
    assert @policy.signature
    refute @policy.signature.include? "\n"
  end


end
