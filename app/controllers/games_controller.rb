class GamesController < ApiController
  before_action :set_game, only: [:show, :update, :destroy]

  # GET /games
  def index
    @season = Season.find(params[:season_id])
    @games = @season.games.includes(:away_team, :home_team, :bets).map do |game|
      hash = {}
      hash[:id] = game.id
      hash[:away_team] = game.away_team.name
      hash[:home_team] = game.home_team.name
      hash[:date] = game.date
      bet = game.bets.first
      if bet
        hash[:away_bet] = bet.away_prediction ? bet.away_prediction.round(2) : "N/A"
        hash[:home_bet] = bet.home_prediction ? bet.home_prediction.round(2) : "N/A"
        hash[:away_score] = bet.away_score
        hash[:home_score] = bet.home_score
      end
      hash
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
