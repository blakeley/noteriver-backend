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
      authToken = user.sessions.create.token
      respond_with :api, :v1, user, meta: {authToken: authToken}
    elsif user.errors[:password].first == "can't be blank"
      render status: :unprocessable_entity, json: {errors: [{title: "Invalid password"}]}
    elsif user.errors[:email].first == "is invalid"
      render status: :unprocessable_entity, json: {errors: [{title: "Invalid email"}]}
    elsif user.errors[:email].first == "has already been taken"
      render status: :unprocessable_entity, json: {errors: [{title: "Email already registered"}]}
    elsif user.errors[:username].first == "can't be blank"
      render status: :unprocessable_entity, json: {errors: [{title: "Invalid username"}]}
    elsif user.errors[:username].first == "has already been taken"
      render status: :unprocessable_entity, json: {errors: [{title: "Username already claimed"}]}
    else
      render status: :unprocessable_entity, json: {errors: [{title: "Bad request"}]}
    end
  end

  def update
    user.update_attributes(user_params)
    respond_with :api, :v1, user
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:data).require(:attributes).permit(:email, :password, :username)
  end
end
