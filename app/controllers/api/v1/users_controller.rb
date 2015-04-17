class API::V1::UsersController < API::V1::APIController

  def index
    respond_with User.all
  end

  def create
    user = User.new(user_params)
    if user.save
      token = user.sessions.create.token
      respond_with :api, :v1, user, meta: {token: token}
    else
      respond_with :api, :v1, user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
