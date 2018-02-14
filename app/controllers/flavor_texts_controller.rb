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
    p = params.require(:flavor_text).permit(FlavorText.column_names)
    p[:trait] = nil if p[:trait] == 'not_applicable'
    p
  end
end
