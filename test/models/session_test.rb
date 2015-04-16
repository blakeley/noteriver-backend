require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  setup do
    @session = sessions(:one)
    @user = users(:one)
  end

  def test_valid
    assert @session.valid?
  end

  def test_belongs_to_user
    assert_not_nil @session.user
    assert_equal @session.user, @user
  end

  def test_generates_token
    session = @user.sessions.create
    assert_not_nil session.token
  end

end
