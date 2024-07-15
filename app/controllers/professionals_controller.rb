class ProfessionalsController < ApplicationController
  def index
    @professionals = Professional.all
    @query_city = params[:query_city]
    if @query_city.present?
      @professionals = @professionals.search_by_city(@query_city)
    end
    render :annuaire
  end

  def show
  end
end
