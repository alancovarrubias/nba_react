class GameDatesController < ApiController
  before_action :set_game_date, only: [:show, :update, :destroy]

  # GET /game_dates
  def index
    @game_dates = GameDate.all

    render json: @game_dates
  end

  # GET /game_dates/1
  def show
    render json: @game_date
  end

  # POST /game_dates
  def create
    @game_date = GameDate.new(game_date_params)

    if @game_date.save
      render json: @game_date, status: :created, location: @game_date
    else
      render json: @game_date.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_dates/1
  def update
    if @game_date.update(game_date_params)
      render json: @game_date
    else
      render json: @game_date.errors, status: :unprocessable_entity
    end
  end

  # DELETE /game_dates/1
  def destroy
    @game_date.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_date
      @game_date = GameDate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_date_params
      params.fetch(:game_date, {})
    end
end
