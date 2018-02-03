class GamesController < ApplicationController
  def new
    @game = Game.create
    10.times do
      @game.officers << Officer.create
    end

    redirect_to edit_game_path(id: @game.id)
  end

  def launch
    @game = Game.find(params[:id])

    assigned_officers = @game.officers.where.not(station: nil)
    if assigned_officers.count != 5
      redirect_to(edit_game_path(id: @game.id), flash: { error: 'A full compliment of officers (5) must be assigned.' }) && return
    end

    # Clean up
    @game.officers.each do |officer|
      officer.delete unless officer.station
    end

    redirect_to game_path(id: @game.id)
  end

  def show
    @game = Game.find(params[:id])
    x = rand(1..10)
    if @game.challenges.present?
      @challenge = @game.challenges.first
    elsif x > 7
      @challenge = Challenge.create(game_id: @game.id)
    else
      @game.update(progress: @game.progress + 1)
    end
  end

  def edit
    @game = Game.find(params[:id])
  end
end
