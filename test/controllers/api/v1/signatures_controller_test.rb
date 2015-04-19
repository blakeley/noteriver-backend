require 'test_helper'

class API::V1::SignaturesControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @policy = Policy.new(
      "expiration_time" => Time.now.utc + 1.hour,
      "bucket" => "noteriver-dev",
      "key" => "uploads/#{@user.id}/s3-test-file.mid",
      "acl" => "public-read",
      "content_type" => "audio/midi",
      "content_length" => 123.kilobytes,
      )
  end

  test "GET /api/v1/signatures/:id with a valid policy and credentials" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    get :show, id: @policy.id
    assert_equal 200, response.status
    assert_equal @policy.signature, response.body
  end

  test "GET /api/v1/signatures/:id with invalid credentials" do
    request.env['HTTP_AUTHORIZATION'] = "invalid"
    get :show, id: @policy.id
    assert_equal 401, response.status
    assert_equal "Invalid authentication token", json["message"]
  end

  test "GET /api/v1/signatures/:id with wrong credentials" do
    request.env['HTTP_AUTHORIZATION'] = users(:two).sessions.first.token
    get :show, id: @policy.id
    assert_equal 403, response.status
    assert_equal "You are not authorized to access this resource.", json["message"]
  end

  test "GET /api/v1/signatures/:id with invalid policy" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    @policy.content_length = 1.gigabyte
    get :show, id: @policy.id
    assert_equal "Invalid policy.", json["message"]
  end

  test "GET /api/v1/signatures/:id with malformed policy" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    get :show, id: '{hi: 5}'
    assert_equal 400, response.status
  end



end
