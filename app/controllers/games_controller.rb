class GamesController < ApplicationController
  before_action :authenticate_user!

  before_action :discover, only: [:show]

  def show
    @game = Game.find(params[:id])

    # 24 hour refuel
    if Time.zone.now > (@game.updated_at + @settings.refuel_countdown_hours.hours)
      @game.supply.update(fuel: @settings.max_fuel)
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :refueled).sample.body,
        game_id: @game.id
      )
    end

    # Game Over!!!
    if @game.supply.shields < 1
      return redirect_to end_game_path
    end

    if params[:order].present? && params[:order] == 'launch'
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :launch).sample.body,
        game_id: @game.id
      )
      @game.update(progress: 0)
    elsif params[:order].present? && params[:order] == 'probe'
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :probe).sample.body,
        game_id: @game.id
      )
      @game.supply.update(last_sci_at: Time.zone.now)
      if @game.stats[:sci] > rand(1..100)
        Message.create(
          source: @game.officers.sample.name,
          body: FlavorText.where(category: :discovery).sample.body,
          game_id: @game.id
        )
        @discovery = Discovery.create(
          player_id: current_user.player.id,
          game_id: @game.id,
          user_id: current_user.id
        )
      else
        Message.create(
          source: @game.officers.sample.name,
          body: FlavorText.where(category: :no_discovery).sample.body,
          game_id: @game.id
        )
      end
    elsif params[:order].present? && params[:order] == 'scan'
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :scan).sample.body,
        game_id: @game.id
      )
      @game.supply.update(last_med_at: Time.zone.now)
      if @game.stats[:med] > rand(1..100)
        Message.create(
          source: @game.officers.sample.name,
          body: FlavorText.where(category: :discovery).sample.body,
          game_id: @game.id
        )
        @discovery = Discovery.create(
          player_id: current_user.player.id,
          game_id: @game.id,
          user_id: current_user.id
        )
      else
        Message.create(
          source: @game.officers.sample.name,
          body: FlavorText.where(category: :no_discovery).sample.body,
          game_id: @game.id
        )
      end
    elsif params[:order].present? && params[:order] == 'repair'
      @game.supply.update(last_eng_at: Time.zone.now)
      @game.supply.repair(10)
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :repair).sample.body,
        game_id: @game.id
      )
    elsif params[:order].present? && params[:order] == 'status'
      return redirect_to status_game_path(id: @game.id)
    elsif params[:order].present? && params[:order] == 'alert'
      @game.supply.update(last_tac_at: Time.zone.now)
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :alert).sample.body,
        game_id: @game.id
      )
    elsif @game.supply.fuel < 1
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :no_fuel).sample.body,
        game_id: @game.id
      )
    elsif @game.challenges.present?
      @challenge = @game.challenges.first
      @flavor_text = FlavorText.find_by(id: @challenge.flavor_text_id)
    elsif params[:order].present? && params[:order] == 'engage' && @settings.encouter_chance >= rand(1..100)
      @challenge = Challenge.create(game_id: @game.id)
      @flavor_text = FlavorText.find_by(id: @challenge.flavor_text_id)
      Message.create(
        source: @game.officers.sample.name,
        body: @challenge.description,
        game_id: @game.id
      )
      Message.create(
        source: @game.officers.sample.name,
        body: "Threat level, #{@challenge.level}!",
        game_id: @game.id
      )
      sleep(0.5);
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :default).sample.body,
        game_id: @game.id
      )
    elsif params[:order].present? && params[:order] == 'engage' && (@settings.discovery_chance >= rand(1..100))
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :discovery).sample.body,
        game_id: @game.id
      )
      @discovery = Discovery.create(
        player_id: current_user.player.id,
        game_id: @game.id,
        user_id: current_user.id
      )
      @game.update(progress: @game.progress + 1)
      @game.supply.expend_fuel(1)
    elsif params[:order].present? && params[:order] == 'engage'
      Message.create(
        source: @game.officers.sample.name,
        body: FlavorText.where(category: :engage).sample.body,
        game_id: @game.id
      )
      @game.update(progress: @game.progress + 1)
      @game.supply.expend_fuel(1)
    else
      # @todo
    end
  end

  def status
    @game = Game.find(params[:id])
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

  def launch
    @game = Game.find(params[:id])

    assigned_officers = @game.officers.assigned
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

    Message.create(
      source: @game.officers.sample.name,
      body: FlavorText.where(category: :launch).sample.body,
      game_id: @game.id
    )
    redirect_to game_path(id: @game.id)
  end

  def end
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to game_path(id: @game.id)
  end

  def starbase
    @game = Game.find(params[:id])

    @discoveries = Discovery.where(logged: true, game_id: @game.id)
    Record.create(
      player_id: current_user.player.id,
      user_id: current_user.id,
      voyage_name: @game.name,
      ship_name: @game.ships.first.name,
      captain_name: current_user.player.name,
      progress: @game.progress,
      points: @game.points,
      discoveries: @discoveries.count
    ) if @game.progress > 0 && @game.points > 0
    @game.update(progress: 0)
    @game.supply.reup
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

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
