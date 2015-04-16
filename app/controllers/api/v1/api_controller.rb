class API::V1::APIController < ApplicationController
  respond_to :json
  before_action :set_default_format
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def render_404
    render status: :not_found, nothing: true
  end

end
