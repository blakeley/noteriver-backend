class API::V1::UsersController < API::V1::APIController

  def index
    respond_with User.all
  end

  def show
    respond_with user
  end

  def create
    user = User.new(user_params)
    if user.save
      token = user.sessions.create.token
      respond_with :api, :v1, user, meta: {token: token}
    else # Not JSON API compliant until v1.0 of active_model_serializers
      respond_with :api, :v1, user
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end
end
