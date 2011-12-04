class ProductsController < MainController
  load_and_authorize_resource :through => :current_account
  before_filter :prepare_comment, except: [:index, :destroy]
  after_filter :log_event, only: [:create, :update, :destroy]
  before_filter :prepare_photo, only: [:show, :edit]

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
    @product = ProductDecorator.decorate(@product)
    @comments = CommentDecorator.decorate(@product.comments.desc(:created_at))

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
    @product.save

    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    #@product = Product.find(params[:id]) loaded by CanCan
    @product.attributes = params[:product]
    @product.save

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
  
  def log_event
    @event = @product.log_event(current_user, action_name)
  end

  # Prepares photo for photo form in product's show and edit actions.
  def prepare_photo
    @photo = Photo.new
  end
end
