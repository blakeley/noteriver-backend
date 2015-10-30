class API::V1::SessionsController < API::V1::APIController

  def create
    user = User.where("lower(email) = ?", session_params[:email].downcase).first
    if user && user.authenticate(session_params[:password])
      authToken = user.sessions.create.token
      render status: :created, json: user, meta: {authToken: authToken}
    elsif user
      render status: :unauthorized, json: {errors: [{title: "Incorrect password"}]}
    else
      render status: :unauthorized, json: {errors: [{title: "Unknown email address"}]}
    end
  end

  def session_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end
end
