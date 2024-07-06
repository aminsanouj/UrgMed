class ProfessionalsController < ApplicationController
  def index
    @professionals = Professional.all
  end

  def show
  end
end
