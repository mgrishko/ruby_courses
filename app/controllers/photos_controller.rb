class PhotosController < MainController
  load_resource :product, through: :current_account
  load_and_authorize_resource through: :product

  respond_to :html, :js

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
    @photo = Photo.new if @photo.errors.empty?
    respond_with(@photo) do |format|
      format.html { redirect_to @product }
    end
  end
end
