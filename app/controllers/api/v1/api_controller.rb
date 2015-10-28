class API::V1::APIController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_default_format
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  respond_to :json

  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def current_user
    @current_user ||= User.includes(:sessions).where("sessions.token" => request.headers[:HTTP_AUTHORIZATION]).first
  end

  def authenticate_user!
    if request.headers[:HTTP_AUTHORIZATION].nil? || current_user.nil?
      render status: :unauthorized, json: {errors: [{title: "Invalid authentication token"}]}
    end
  end

  def render_404
    render status: :not_found, nothing: true
  end

  def render_400
    render status: :bad_request, nothing: true
  end

end
