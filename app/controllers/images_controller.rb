class ImagesController < ApplicationController
  before_filter :require_user
  before_filter :find_item

  def upload
    @original = OriginalImage.new(params[:image])

    if @original.test_and_prepare?
      @image = Image.new()
      @image.item_id = @item.id
      @image.base_item_id = params[:base_item_id]
      @image.save
      Event.log(current_user,@image)
      #Create a new image from source according to Image_Parameters(small, medium, large)
      for image_parameter in Webforms::IMAGE_PARAMETERS do
      	if @image.resize(@original.raw, image_parameter['width'], image_parameter['height'], image_parameter['scale'], image_parameter['fill'], image_parameter['name'])
      	else
      	  # sth wrong
      	end
      end
    else
      # wrong picture
    end
    responds_to_parent do
      render :update do |page|
	page << "$j('#link_upload').show(); $j('#form_upload').hide();"
	page << "$j('#item_image').attr('src','#{@item.image_url}')" if @image
	page << "$j('#iil').attr('href', '#{@item.image_url('big')}')" if @image
      end
    end
  end

  private

  def find_item
    @item = current_user.items.find(params[:item_id])
  end

end

