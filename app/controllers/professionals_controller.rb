class ProfessionalsController < ApplicationController
  def index
    @search_query_city = params[:query_city].presence
    @open_now = params[:open_now] == 'true'
    @professionals = Professional.all

    if @search_query_city.present?
      @search_query_coordinates = Geocoder.coordinates(@search_query_city)
      if @search_query_coordinates.present?
        @professionals = @professionals.near(@search_query_coordinates, 50)
      end
    else
      @search_query_city = ""
      @search_query_coordinates = []
    end

    render :annuaire
  end

  def show
    @professional = Professional.find(params[:id])
  end
end
