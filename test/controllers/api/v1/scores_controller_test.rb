require 'test_helper'

class API::V1::ScoresControllerTest < ActionController::TestCase

  test "GET /api/v1/scores" do
    get :index
    assert_equal 200, response.status
    refute_empty json["scores"]
    assert_equal scores(:one).artist, json["scores"][0]["artist"]
    assert_equal scores(:one).title, json["scores"][0]["title"]
    assert_equal scores(:one).user.id, json["scores"][0]["user_id"]
    assert_equal Score.count, json["scores"].length
  end

end
