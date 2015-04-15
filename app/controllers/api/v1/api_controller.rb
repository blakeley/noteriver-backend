class API::V1::APIController < ApplicationController
  respond_to :json
  before_action :set_default_format

  def set_default_format
    request.format = :json unless params[:format]
  end

end
