require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  # GET /api/v1/users

  test 'GET /api/v1/users' do
    get :index
    assert_equal 200, response.status
    assert_equal @user.id, json['data'][0]['id'].to_i
    assert_equal @user.scores.last.id, json['data'][0]['relationships']['scores']['data'][0]['id'].to_i
  end

  # GET /api/v1/users/:id

  test 'GET /api/v1/users/:id' do
    get :show, id: @user.id
    assert_equal 200, response.status
    assert_equal @user.id, json['data']['id'].to_i
    assert_equal @user.scores.last.id, json['data']['relationships']['scores']['data'][0]['id'].to_i
  end

  # POST /api/v1/users

  test 'POST /api/v1/users with valid registration' do
    assert_difference ->{User.count}, 1 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'new@mail.com',
          password: 'password'
        }
      }
    end

    assert_equal 201, response.status
    assert_equal User.last.id, json['data']['id'].to_i
    assert_equal User.last.sessions.last.token, json['meta']['authToken']
  end

  test 'POST /api/v1/users with invalid email' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'invalid',
          password: 'password'
        }
      }
    end

    assert_equal 422, response.status
    # assert_equal 'Not a valid email address', json['errors'][0]['title']
  end

  test 'POST /api/v1/users with existing email' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: @user.email,
          password: 'password'
        }
      }
    end

    assert_equal 422, response.status
    # assert_equal 'This email has already been registered', json['errors'][0]['title']
  end

  test 'POST /api/v1/users without password' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'new@mail.com',
          password: ''
        }
      }
    end

    assert_equal 422, response.status
    # assert_equal 'can't be blank', json['errors'][0]['title']
  end


end
