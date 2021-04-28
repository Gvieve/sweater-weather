class Api::V1::ForecastController < ApplicationController

  def index
    forecast = ForecastFacade.get_forecast(params)
    return render_invalid_params if forecast.nil?
    render json: ForecastSerializer.new(forecast)
  end
end
