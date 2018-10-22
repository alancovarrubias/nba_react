class GamesController < ApiController
  PERIODS = [0, 1, 2, 3, 4]
  before_action :set_game, only: [:show, :update, :destroy]

  # GET /games
  def index
    @season = Season.find(params[:season_id])
    @games = {}
    PERIODS.each do |period|
      @games[period] = @season.games.map { |game| game.index_data(period) }
    end
    @season = @season.as_json

    render json: { games: @games, season: @season }
  end

  # GET /games/1
  def show
    game = Game.find(params[:id])
    render json: @game.show_data
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    if @game.save
      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.fetch(:game, {})
    end
end
