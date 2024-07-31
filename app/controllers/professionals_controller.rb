class ProfessionalsController < ApplicationController
  def index
    @professionals = Professional.all
    @query_city = params[:query_city]
    @open_now = params[:open_now] == 'true'

    if @query_city.present?
      @professionals = @professionals.search_by_city(@query_city)
    end

    if @open_now
      @professionals = @professionals.to_a.select(&:open_now?)
    end

    render :annuaire
  end

  def show
  end
end
