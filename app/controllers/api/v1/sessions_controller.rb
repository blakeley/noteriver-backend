class API::V1::SessionsController < API::V1::APIController

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      render status: :created, json: user, meta: {token: user.sessions.create.token}
    elsif user
      render status: :unauthorized, json: {message: "Incorrect password"}
    else
      render status: :unauthorized, json: {message: "Unknown email address"}
    end
  end

end
