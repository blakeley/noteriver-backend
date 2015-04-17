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

  def test_s3key_presence
    @score.s3key = nil
    assert @score.invalid?
  end

  def test_belongs_to_user
    assert_not_nil @score.user
    assert_equal @score.user, @user
  end

end
