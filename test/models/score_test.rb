require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @score = scores(:one)
  end

  def test_valid
    assert @score.valid?
  end

  def test_title_presence
    @score.artist = nil
    assert @score.invalid?
  end

  def test_artist_presence
    @score.artist = nil
    assert @score.invalid?
  end

  def test_s3_key_presence
    @score.s3_key = nil
    assert @score.invalid?
  end

  def test_belongs_to_user
    assert_not_nil @score.user
    assert_equal @score.user, @user
  end

  def test_search_matches_artist
    assert_includes Score.search(@score.artist[1..-1]), @score
  end

  def test_search_matches_title
    assert_includes Score.search(@score.title[1..-1]), @score
  end

  test "search is case insensitive" do
    assert_includes Score.search(@score.title.upcase), @score
  end

  test "search with empty string matches everything" do
    assert_equal Score.search('').count, Score.count
  end
end
