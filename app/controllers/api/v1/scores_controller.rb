class API::V1::ScoresController < API::V1::APIController

  def index
    respond_with Score.all
  end

end
