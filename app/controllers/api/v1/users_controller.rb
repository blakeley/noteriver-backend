class API::V1::UsersController < API::V1::APIController

  def create
    user = User.create(user_params)
    respond_with :api, :v1, user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
