require 'test_helper'

class API::V1::ScoresControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @score = scores(:one)
  end

  test "GET /api/v1/scores" do
    get :index
    assert_equal 200, response.status
    refute_empty json["scores"]
    assert_equal @score.artist, json["scores"][0]["artist"]
    assert_equal @score.title, json["scores"][0]["title"]
    assert_equal @score.s3_key, json["scores"][0]["s3_key"]
    assert_equal @score.user.id, json["scores"][0]["user_id"]
    assert_equal @score.created_at, json["scores"][0]["created_at"]
    assert_equal Score.count, json["scores"].length
  end

  test "GET /api/v1/scores/:id" do
    get :show, id: @score.id
    assert_equal 200, response.status
    assert_equal @score.id, json["score"]["id"]
    assert_equal @score.artist, json["score"]["artist"]
    assert_equal @score.title, json["score"]["title"]
    assert_equal @score.s3_key, json["score"]["s3_key"]
    assert_equal @score.user.id, json["score"]["user_id"]
    assert_equal @score.created_at, json["score"]["created_at"]
  end

  test "GET /api/v1/scores/:id with unknown id" do
    get :show, id: -1
    assert_equal 404, response.status
  end

  # POST /api/v1/scores

  test "POST /api/v1/scores with valid fields and credentials" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 1 do 
      post :create, score: {title: "Title", artist: "Artist", s3_key: "key"}
    end

    assert_equal 201, response.status
  end

  test "POST /api/v1/scores without credentials" do
    request.env['HTTP_AUTHORIZATION'] = nil
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, score: {title: "Title", artist: "Artist", s3_key: "key"}
    end

    assert_equal 401, response.status
  end

  test "POST /api/v1/scores without a title" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, score: {artist: "Artist", s3_key: "key"}
    end

    assert_equal 422, response.status
    assert_not_nil json["errors"]
    assert_equal "can't be blank", json["errors"]["title"][0]
  end

  test "POST /api/v1/scores without an artist" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, score: {title: "Title", s3_key: "key"}
    end

    assert_equal 422, response.status
    assert_equal "can't be blank", json["errors"]["artist"][0]
  end

  test "POST /api/v1/scores without an s3_key" do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    assert_difference ->{@user.scores.count}, 0 do 
      post :create, score: {title: "Title", artist: "Artist"}
    end

    assert_equal 422, response.status
    assert_equal "can't be blank", json["errors"]["s3_key"][0]
  end

end
