class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_admin

  def edit
  end

  def update
    @settings.update(setting_fields)
    flash[:info] = 'Updated!'
    redirect_to edit_setting_path(id: @settings.id)
  end

  private

  def setting_fields
    params.require(:setting).permit(Setting.column_names)
  end
end
