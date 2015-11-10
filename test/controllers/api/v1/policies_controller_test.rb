require 'test_helper'

class API::V1::PoliciesControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @policy = Policy.new(
      "expiration" => (Time.now.utc + 1.hour).iso8601,
      "bucket" => "noteriver-dev",
      "key" => "uploads/#{@user.id}/s3-test-file.mid",
      "acl" => "public-read",
      "content_type" => "audio/midi",
      "content_length" => 123.kilobytes,
      )
  end

  test "GET /api/v1/policies/:id with a valid policy and credentials" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    get :show, id: @policy.id
    assert_equal 200, response.status
    assert_equal @policy.id, json["data"]["id"]
    assert_equal @policy.signature, json["data"]["attributes"]["signature"]
    assert_equal @policy.user_id, json["data"]["relationships"]["user"]["data"]["id"].to_i
  end

  test "GET /api/v1/policies/:id with invalid credentials" do
    request.env['HTTP_AUTHORIZATION'] = "invalid"
    get :show, id: @policy.id
    assert_equal 401, response.status
    assert_equal "Invalid authentication token", json["errors"][0]["title"]
  end

  test "GET /api/v1/policies/:id with wrong credentials" do
    request.env['HTTP_AUTHORIZATION'] = users(:two).sessions.first.token
    get :show, id: @policy.id
    assert_equal 403, response.status
    assert_equal "You are not authorized to access this resource", json["errors"][0]["title"]
  end

  test "GET /api/v1/policies/:id with invalid policy" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    @policy.content_length = 1.gigabyte
    get :show, id: @policy.id
    assert_equal "Invalid policy", json["errors"][0]["title"]
  end

  test "GET /api/v1/policies/:id with malformed policy" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    get :show, id: '{hi: 5}'
    assert_equal 400, response.status
  end
end
