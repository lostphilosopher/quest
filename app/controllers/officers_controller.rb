class OfficersController < ApplicationController
  def update
    @officer = Officer.find(params[:id])

    @officer.update(officer_params)

    redirect_to edit_game_path(id: params[:game_id])
  end

  private

  def officer_params
    params.require(:officer).permit(:station)
  end
end
