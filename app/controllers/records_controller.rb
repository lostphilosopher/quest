class RecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @records = Record.all
  end
end
