class PhotosController < MainController
  load_resource :product, through: :current_account
  load_and_authorize_resource through: :product
  after_filter :log_event, only: [:create]
  
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
  
  # Logs photo creation
  def log_event
    @product.log_event(current_membership, action_name, @product) if @photo.errors.empty?
  end
end
