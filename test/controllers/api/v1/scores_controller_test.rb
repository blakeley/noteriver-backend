require 'test_helper'

class API::V1::ScoresControllerTest < ActionController::TestCase

  setup do
    @score = scores(:one)
  end

  test "GET /api/v1/scores" do
    get :index
    assert_equal 200, response.status
    refute_empty json["scores"]
    assert_equal @score.artist, json["scores"][0]["artist"]
    assert_equal @score.title, json["scores"][0]["title"]
    assert_equal @score.s3key, json["scores"][0]["s3key"]
    assert_equal @score.user.id, json["scores"][0]["user_id"]
    assert_equal Score.count, json["scores"].length
  end

  test "GET /api/v1/scores/:id" do
    get :show, id: @score.id
    assert_equal 200, response.status
    assert_equal @score.id, json["score"]["id"]
    assert_equal @score.artist, json["score"]["artist"]
    assert_equal @score.title, json["score"]["title"]
    assert_equal @score.s3key, json["score"]["s3key"]
    assert_equal @score.user.id, json["score"]["user_id"]
  end

  test "GET /api/v1/scores/:id with unknown id" do
    get :show, id: -1
    assert_equal 404, response.status
  end

end
