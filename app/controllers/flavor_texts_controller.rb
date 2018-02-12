class FlavorTextsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_admin

  def new
    @flavor_text = FlavorText.new
  end

  def create
    @flavor_text = FlavorText.create(flavor_text_params)
    redirect_to flavor_text_path(id: @flavor_text.id)
  end

  def edit
    @flavor_text = FlavorText.find_by(id: params[:id])
  end

  def update
    @flavor_text = FlavorText.find_by(id: params[:id])
    @flavor_text.update(flavor_text_params)
    redirect_to flavor_text_path(id: @flavor_text.id)
  end

  def show
    @flavor_text = FlavorText.find_by(id: params[:id])
  end

  private

  def flavor_text_params
    p = params.require(:flavor_text).permit(
      :body,
      :category,
      :trait,
      :cmd_order,
      :cmd_success,
      :cmd_failed,
      :sci_order,
      :sci_success,
      :sci_failed,
      :tac_order,
      :tac_success,
      :tac_failed,
      :med_order,
      :emd_success,
      :med_failed,
      :eng_order,
      :eng_success,
      :eng_failed
    )
    p[:trait] = nil if p[:trait] == 'not_applicable'
    p
  end
end
