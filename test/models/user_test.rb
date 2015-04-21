require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @session = sessions(:one)
    @score = scores(:one)
  end

  def test_valid
    assert @user.valid?
  end

  def test_email_presence
    @user.email = nil
    assert @user.invalid?
  end

  def test_email_validity
    @user.email = 'invalid email address'
    assert @user.invalid?
  end

  def test_email_uniqueness
    new_user = User.new(email: @user.email, password: 'password')
    assert new_user.invalid?
  end

  def test_email_uniqueness_case_insensitive
    new_user = User.new(email: @user.email.upcase, password: 'password')
    assert new_user.invalid?
  end

  def test_password_presence
    @user.password = nil
    assert @user.invalid?
  end

  def test_has_many_sessions
    assert_not_nil @user.sessions
    assert_includes @user.sessions, @session
  end

  def test_has_many_sessions
    assert_not_nil @user.scores
    assert_includes @user.scores, @score
  end
end
