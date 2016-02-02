class API::V1::ScoresController < API::V1::APIController
  before_action :authenticate_user!, only: [:create]

  def create
    respond_with :api, :v1, current_user.scores.create(score_params)
  end

  def show
    respond_with score
  end

  def index
    respond_with Score.search(params[:search])
  end

  private

  def score
    @score ||= Score.find(params[:id])
  end

  def score_params
    params.require(:data).require(:attributes).permit(:title, :artist, 's3-key').transform_keys{|key| key.underscore}
  end
end
