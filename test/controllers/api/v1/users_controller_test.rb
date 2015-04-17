require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  # GET /api/v1/users

  test "GET /api/v1/users" do
    get :index
    assert_equal 200, response.status
    assert_equal @user.id, json["users"][0]["id"]
  end

  # POST /api/v1/users

  test "POST /api/v1/users with valid registration" do
    assert_difference ->{User.count}, 1 do
      post :create, user: {email: 'new@mail.com', password: 'password'}
    end

    assert_equal 201, response.status
    assert_equal User.last.id, json["user"]["id"]
    assert_equal User.last.sessions.last.token, json["meta"]["token"]
  end

  test "POST /api/v1/users with invalid email" do
    assert_difference ->{User.count}, 0 do
      post :create, user: {email: 'invalid', password: 'password'}
    end

    assert_equal 422, response.status
    assert_equal "is invalid", json["errors"]["email"][0]
  end

  test "POST /api/v1/users with existing email" do
    assert_difference ->{User.count}, 0 do
      post :create, user: {email: 'one@mail.com', password: 'password'}
    end

    assert_equal 422, response.status
    assert_equal "has already been taken", json["errors"]["email"][0]
  end

  test "POST /api/v1/users without password" do
    assert_difference ->{User.count}, 0 do
      post :create, user: {email: 'new@mail.com', password: ''}
    end

    assert_equal 422, response.status
    assert_equal "can't be blank", json["errors"]["password"][0]
  end


end
