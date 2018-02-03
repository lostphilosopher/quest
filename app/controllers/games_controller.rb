class GamesController < ApplicationController
  before_action :authenticate_user!

  before_action :discover, only: [:show]

  def index
    @game = current_user.game
  end

  def destroy
    @game = Game.find_by(id: params[:id])

    high_score = User.where(id: current_user.id).maximum(:high_score) || 0
    if @game.points > high_score
      current_user.update(
        high_score: @game.points,
        high_score_ship: @game.ships.first.name
      )
    end

    furthest_journey = User.where(id: current_user.id).maximum(:furthest_journey) || 0
    if @game.progress > furthest_journey
      current_user.update(
        furthest_journey: @game.progress,
        furthest_journey_ship: @game.ships.first.name
      )
    end

    @game.destroy

    redirect_to games_path
  end

  def new
    # Clean up old games
    Game.where(user_id: current_user.id).each do |game|
      game.destory
    end

    @game = Game.create(user_id: current_user.id)
    10.times do
      @game.officers << Officer.create
    end
    3.times do
      @game.ships << Ship.create
    end

    redirect_to edit_game_path(id: @game.id)
  end

  def launch
    @game = Game.find(params[:id])

    assigned_officers = @game.officers.where.not(station: '')
    if assigned_officers.count != 5
      redirect_to(edit_game_path(id: @game.id), flash: { error: 'A full compliment of officers (5) must be assigned.' }) && return
    end

    ship = @game.ships.where(commanded: true)
    if ship.count != 1
      redirect_to(edit_game_path(id: @game.id), flash: { error: 'A single ship must be selected to command.' }) && return
    end

    @game.supply = Supply.create

    # Clean up
    @game.officers.each do |officer|
      officer.delete unless officer.station.present?
    end

    @game.ships.each do |ship|
      ship.delete unless ship.commanded
    end

    redirect_to game_path(id: @game.id)
  end

  def show
    @game = Game.find(params[:id])

    # Game Over!!!
    if @game.supply.fuel < 1
      @game.destroy
      return redirect_to root_path
    end

    x = rand(1..10)
    if @game.challenges.present?
      @challenge = @game.challenges.first
    elsif params[:direction].present? && x > 7
      @challenge = Challenge.create(game_id: @game.id)
    elsif params[:direction].present?
      @game.update(progress: @game.progress + 1)
      @game.supply.expend_fuel(1)
    else
      # Do nothing on page refresh
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  private

  def discover
    @game = Game.find(params[:id])

    r = @game.progress / 20

    @region = Region.find_by(range: r)

    # Player has discovered a new region
    unless @region
      @region = Region.create(
        user_id: current_user.id,
        name: Faker::Ancient.primordial,
        range: r
      )
    end
  end
end
