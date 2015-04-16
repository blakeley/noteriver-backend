class API::V1::ScoresController < API::V1::APIController

  def index
    respond_with Score.all
  end

  def show
    respond_with score
  end

  private

  def score
    @score ||= Score.find(params[:id])
  end


end
