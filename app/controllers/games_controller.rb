class GamesController < ApplicationController
  before_action :authenticate_user!

  before_action :discover, only: [:show]

  def show
    @game = Game.find(params[:id])

    # 24 hour refuel
    if Time.zone.now > (@game.updated_at + @settings.refuel_countdown_hours.hours)
      @game.supply.update(fuel: @settings.max_fuel)
      flash[:game] = "Engines recharged! Standing by."
    end

    # Game Over!!!
    if @game.supply.shields < 1
      return redirect_to end_game_path
    end

    x = rand(1..100)
    if @game.supply.fuel < 1
      flash[:game] = "We're out of fuel. It will take 24 hours for the engines to recharge."
    elsif params[:launch].present?
      flash[:game] = "We've left space dock."
      @game.update(progress: 0)
    elsif @game.challenges.present?
      flash[:game] = "Sensors detecting a threat, bringing it up now."
      @challenge = @game.challenges.first
    elsif params[:direction].present? && x > @settings.encoutering_challenge
      flash[:game] = "Sensors detecting a threat, bringing it up now."
      @challenge = Challenge.create(game_id: @game.id)
    elsif params[:direction].present? && (@settings.discovery_chance <= rand(1..100))
      flash[:game] = "We've made a discovery Captain!"
      Discovery.create(
        player_id: current_user.player.id,
        game_id: @game.id,
        user_id: current_user.id
      )
    elsif params[:direction].present?
      msg = [
        "We\'ve arrived, awaiting orders.",
        "Done.",
        "Complete",
        "All stations ready",
        "Your orders Captain?",
        "Where to?",
        "Standing by Captain."
      ].sample
      flash[:game] = msg
      @game.update(progress: @game.progress + 1)
      @game.supply.expend_fuel(1)
    else
      flash[:game] = flash[:game]
    end
  end

  def index
    @game = current_user.game
  end

  def destroy
    @game = Game.find_by(id: params[:id])

    @record = Record.create(
      user_id: current_user.id,
      ship_name: current_user.game.ships.first.name,
      captain_name: current_user.player.name,
      progress: current_user.game.progress,
      points: current_user.game.points
    )

    # Clean up unclaimed discoveries
    @game.discoveries.where.not(logged: true).each do |discovery|
      discovery.destroy
    end

    @game.destroy

    redirect_to games_path
  end

  def new
    # Clean up old games
    Game.where(user_id: current_user.id).each do |game|
      game.destroy
    end

    @game = Game.create(user_id: current_user.id)
    @settings.officers_to_choose_from.times do
      @game.officers << Officer.create
    end
    @settings.ships_to_choose_from.times do
      @game.ships << Ship.create
    end

    redirect_to edit_game_path(id: @game.id)
  end

  def repair
    @game = Game.find(params[:id])
    @game.supply.repair(10)

    redirect_to game_path(id: @game.id)
  end

  def launch
    @game = Game.find(params[:id])

    assigned_officers = @game.officers.where.not(station: '')
    if assigned_officers.count != 5 # Not a setting
      redirect_to(edit_game_path(id: @game.id), flash: { error: 'A full compliment of officers (5) must be assigned.' }) && return
    end

    ship = @game.ships.where(commanded: true)
    if ship.count != 1 # Not a setting
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

    flash[:game] = "We've left space dock, awaiting orders Captain."
    redirect_to game_path(id: @game.id)
  end

  def end
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def starbase
    @game = Game.find(params[:id])
    @game.supply.reup
  end

  private

  def discover
    @game = Game.find(params[:id])

    r = @game.progress / 20 # Not a setting

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
