require 'test_helper'

class API::V1::ScoresControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @score = scores(:one)
  end

  test "GET /api/v1/scores" do
    get :index
    assert_equal 200, response.status
    refute_empty json["data"]
    assert_equal @score.artist, json["data"][0]["attributes"]["artist"]
    assert_equal @score.title, json["data"][0]["attributes"]["title"]
    assert_equal @score.s3_key, json["data"][0]["attributes"]["s3-key"]
    assert_equal @score.created_at, json["data"][0]["attributes"]["created-at"]
    assert_equal @score.user.id, json["data"][0]["relationships"]["user"]["data"]["id"].to_i
    assert_equal Score.count, json["data"].length
  end

  test "GET /api/v1/scores/:id" do
    get :show, id: @score.id
    assert_equal 200, response.status
    assert_equal @score.id, json["data"]["id"].to_i
    assert_equal @score.artist, json["data"]["attributes"]["artist"]
    assert_equal @score.title, json["data"]["attributes"]["title"]
    assert_equal @score.s3_key, json["data"]["attributes"]["s3-key"]
    assert_equal @score.created_at, json["data"]["attributes"]["created-at"]
    assert_equal @score.user.id, json["data"]["relationships"]["user"]["data"]["id"].to_i
  end

  test "GET /api/v1/scores/:id with unknown id" do
    get :show, id: -1
    assert_equal 404, response.status
  end

  # POST /api/v1/scores

  test "POST /api/v1/scores with valid fields and credentials" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 1 do 
      post :create, data: {
        type: 'scores',
        attributes: {
          title: 'Title',
          artist: 'Artist',
          's3-key': 'key'
        }
      }
    end

    assert_equal 201, response.status
  end

  test "POST /api/v1/scores without credentials" do
    request.env['HTTP_AUTHORIZATION'] = nil
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, data: {
        type: 'scores',
        attributes: {
          title: 'Title',
          artist: 'Artist',
          's3-key': 'key'
        }
      }
    end

    assert_equal 401, response.status
  end

  test "POST /api/v1/scores without a title" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do
      post :create, data: {
        type: 'scores',
        attributes: {
          artist: 'Artist',
          's3-key': 'key'
        }
      }
    end

    assert_equal 422, response.status
    assert_not_nil json["errors"]
    # assert_equal "can't be blank", json["errors"][0]["title"]
  end

  test "POST /api/v1/scores without an artist" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, data: {
        type: 'scores',
        attributes: {
          title: 'Title',
          's3-key': 'key'
        }
      }
    end

    assert_equal 422, response.status
    # assert_equal "can't be blank", json["errors"][0]["artist"]
  end

  test "POST /api/v1/scores without an s3_key" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, data: {
        type: 'scores',
        attributes: {
          title: 'Title',
          artist: 'Artist',
        }
      }
    end

    assert_equal 422, response.status
    # assert_equal "can't be blank", json["errors"][0]["s3-key"]
  end

end
