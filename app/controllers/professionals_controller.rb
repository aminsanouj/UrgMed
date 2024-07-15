class ProfessionalsController < ApplicationController
  def index
    @professionals = Professional.all
    render :annuaire
  end

  def show
  end
end
