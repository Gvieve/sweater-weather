class Api::V1::BackgroundsController < ApplicationController

  def index
    image = BackgroundsFacade.find_background(params)
    return render_invalid_params if image.nil?
    render json: ImageSerializer.new(image)
  end
end
