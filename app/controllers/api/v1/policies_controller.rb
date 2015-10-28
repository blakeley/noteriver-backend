class API::V1::PoliciesController < API::V1::APIController
  before_action :authenticate_user!
  before_action :authorize_user!
  rescue_from Exception, with: :render_400

  def show
    if policy.valid?
      respond_with policy
    else
      render status: :forbidden, json: {errors: [{title: "Invalid policy"}]}
    end
  end

  private

  def policy
    @policy ||= Policy.find(params[:id])
  end

  def authorize_user!
    if policy.user_id != current_user.id
      render status: :forbidden, json: {errors: [{title: "You are not authorized to access this resource"}]}
    end
  end
end
