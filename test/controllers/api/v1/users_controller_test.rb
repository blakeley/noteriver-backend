require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @other_user = users(:two)
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
    assert_equal @user.username, json['data']['attributes']['username']
    assert_equal @user.email_md5, json['data']['attributes']['email-md5']
  end

  # POST /api/v1/users

  test 'POST /api/v1/users with valid registration' do
    assert_difference ->{User.count}, 1 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'new@mail.com',
          password: 'password',
          username: 'new-user',
        }
      }
    end

    assert_equal 201, response.status
    assert_equal User.last.id, json['data']['id'].to_i
    assert_equal User.last.sessions.last.token, json['meta']['authToken']
    assert_equal User.last.email_md5, json['data']['attributes']['email-md5']
  end

  test 'POST /api/v1/users with invalid email' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'invalid',
          password: 'password',
          username: 'new-user',
        }
      }
    end

    assert_equal 422, response.status
    assert_equal 'Invalid email', json['errors'][0]['title']
  end

  test 'POST /api/v1/users with existing email' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: @user.email,
          password: 'password',
          username: 'new-user',
        }
      }
    end

    assert_equal 422, response.status
    assert_equal 'Email already registered', json['errors'][0]['title']
  end

  test 'POST /api/v1/users without password' do
    assert_difference ->{User.count}, 0 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'new@mail.com',
          password: '',
          username: 'new-user',
        }
      }
    end

    assert_equal 422, response.status
    assert_equal 'Invalid password', json['errors'][0]['title']
  end

  test 'POST /api/v1/users without username' do
    assert_difference ->{User.count}, 1 do
      post :create, data: {
        type: 'users',
        attributes: {
          email: 'new@mail.com',
          password: 'password',
        }
      }
    end

    assert_equal 201, response.status
    assert_not_nil json['data']['attributes']['username']
  end

  # PATCH /api/v1/users

  test 'PATCH /api/v1/users/:id with valid credentials' do
    request.env['HTTP_AUTHORIZATION'] = @user.sessions.first.token
    patch :update, id: @user.id, data: {
      type: 'users',
      id: @user.id,
      attributes: {
        username: 'updated-username'
      }
    }

    @user.reload
    assert_equal 204, response.status
    assert_equal 'updated-username', @user.username
  end

  test 'PATCH /api/v1/users/:id with invalid credentials' do
    request.env['HTTP_AUTHORIZATION'] = @other_user.sessions.first.token
    patch :update, id: @user.id, data: {
      type: 'users',
      id: @user.id,
      attributes: {
        username: 'updated-username'
      }
    }

    @user.reload
    assert_equal 403, response.status
    assert_not_nil json['errors']
    refute_equal 'updated-username', @user.username
  end



end
