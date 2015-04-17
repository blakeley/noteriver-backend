class API::V1::ScoresController < API::V1::APIController
  before_action :authenticate_user!, only: [:create]

  def create
    respond_with :api, :v1, current_user.scores.create(score_params)
  end

  def show
    respond_with score
  end

  def index
    respond_with Score.all
  end

  private

  def score
    @score ||= Score.find(params[:id])
  end

  def score_params
    params.require(:score).permit(:title, :artist, :s3_key)
  end



end
