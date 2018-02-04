class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :load_settings

  private

  def validate_admin
    redirect_to root_path unless current_user && current_user.admin?
  end

  def load_settings
    @settings = Setting.first_or_create
  end
end
