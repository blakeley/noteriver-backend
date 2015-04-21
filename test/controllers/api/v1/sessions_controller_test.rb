require 'test_helper'

class API::V1::SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  # POST /api/v1/sessions

  test "POST /api/v1/sessions with valid registration" do
    assert_difference ->{Session.count}, 1 do
      post :create, {email: @user.email, password: "password"}
    end

    assert_equal 201, response.status
    assert_equal @user.id, json["user"]["id"]
    assert_equal @user.sessions.last.token, json["meta"]["token"]
  end

  test "POST /api/v1/sessions with uppercase email" do
    assert_difference ->{Session.count}, 1 do
      post :create, {email: @user.email.upcase, password: "password"}
    end

    assert_equal 201, response.status
    assert_equal @user.id, json["user"]["id"]
    assert_equal @user.sessions.last.token, json["meta"]["token"]
  end

  test "POST /api/v1/sessions with an incorrect password" do
    assert_difference ->{Session.count}, 0 do
      post :create, {email: @user.email, password: "wrong"}
    end

    assert_equal 401, response.status
    assert_equal "Incorrect password", json["message"]
  end

  test "POST /api/v1/sessions with unknown email address" do
    assert_difference ->{Session.count}, 0 do
      post :create, {email: "unknown@mail.com", password: "password"}
    end

    assert_equal 401, response.status
    assert_equal "Unknown email address", json["message"]
  end

end
