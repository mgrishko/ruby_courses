class PhotosController < MainController
  load_resource :product, through: :current_account
  load_and_authorize_resource through: :product
  
  respond_to :js

  def show
    respond_with(@photo)
  end

  # POST /photos
  # POST /photos.xml
  def create
    #@photo = Photo.new(params[:photo]) # loaded by cancan
    @photo.save

    @photo = PhotoDecorator.decorate(@photo)
    respond_with(@photo) do |format|
      format.html { redirect_to @product }
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    #@photo = Photo.find(params[:id]) # loaded by cancan
    @photo.destroy
    prepare_photo

    respond_with(@photo) do |format|
      format.html { redirect_to @product }
    end
  end

  private

  def prepare_photo
    if @photo.errors.empty?
      @photo = @product.photos.empty? ? Photo.new : @product.photos.last
    end
  end
end
