class ProductsController < MainController
  include AutoComplete::Action
  load_and_authorize_resource :through => :current_account
  before_filter :prepare_comment, except: [:index, :destroy, :autocomplete]
  before_filter :prepare_photo, only: [:show, :edit, :update]
  after_filter :log_event, only: [:create, :update, :destroy]
  before_filter :load_version, only: [:show]

  # GET /products
  # GET /products.xml
  def index
    #@products = Product.all loaded by CanCan
    @products = ProductDecorator.decorate(@products)
    respond_with(@products)
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    #@product = Product.find(params[:id]) loaded by CanCan
    @comments = CommentDecorator.decorate(@product.comments.desc(:created_at))
    @product = ProductDecorator.decorate(@product)

    respond_with(@product)
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    #@product = Product.new loaded by CanCan
    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # GET /products/1/edit
  def edit
    #@product = Product.find(params[:id]) loaded by CanCan
    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # POST /products
  # POST /products.xml
  def create
    #@product = Product.new(params[:product]) loaded by CanCan
    @product.save_with_system_comment(current_user)
    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    #@product = Product.find(params[:id]) loaded by CanCan
    @product.attributes = params[:product]
    @product.save_with_system_comment(current_user)
    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    #@product = Product.find(params[:id]) loaded by CanCan
    @product.destroy
    respond_with(@product)
  end

  private

  # Prepares comment for show, new and edit actions.
  def prepare_comment
    @comment = @product.prepare_comment(current_user, params[:comment])
  end
  
  # Logs added, updated, destroyed events of product. On create and update
  # binds the system comment to the event
  def log_event
    return unless @product.errors.empty?

    event = @product.log_event(current_membership, action_name)
    comment = @product.comments.last
    if comment
      comment.event = event
      comment.save
    end
  end

  # Load product version if version param is present
  def load_version
    @product_version = params[:version] ?
        @product.versions.where(version: params[:version]).first : @product

    @product_version = ProductDecorator.decorate(@product_version)
  end
  
  # Prepares photo for photo form in product's show and edit actions.
  def prepare_photo
    @photo = Photo.new
  end
end
