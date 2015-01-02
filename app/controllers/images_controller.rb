class ImagesController < ApplicationController
  authorize_resource
  def create
    @image = Image.new(image_params)

    if @image.save
      render json: @image
    else
      head :bad_request
    end
  end

  def index
    imageable_type = image_params[:imageable_type]
    imageable_id = image_params[:imageable_id]

    if imageable_type == "Product" #Add here more imageable Classes
      imageable_class = imageable_type.classify.constantize
      @imageable = imageable_class.find_by(id: imageable_id)
      unless @imageable.nil?
        @images = @imageable.images
      else
        @images = nil
      end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    if @image.destroy
      render json: { message: "Image deleted from server" }
    else
      render json: { message: @image.errors.full_messages.join(',') }
    end
  end

  private

  def image_params
    params.require(:image).permit(:image, :imageable_id, :imageable_type)
  end

end
