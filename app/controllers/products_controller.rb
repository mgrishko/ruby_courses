class ProductsController < MainController
  load_and_authorize_resource :through => :current_account

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
    
    _version = params[:version] ? params[:version].to_i : @product.version
    
    if _version < @product.version
      versioned_attributes = @product.versions.where(:version => _version).first.versioned_attributes
      versioned_attributes.delete("version")
      @product.attributes = versioned_attributes
    end
    
    @product = ProductDecorator.decorate(@product)
    respond_with(@product)
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    #@product = Product.new loaded by CanCan
    respond_with(@product)
  end

  # GET /products/1/edit
  def edit
    #@product = Product.find(params[:id]) loaded by CanCan
    respond_with(@product)
  end

  # POST /products
  # POST /products.xml
  def create
    #@product = Product.new(params[:product]) loaded by CanCan
    @product.save
    respond_with(@product)
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    #@product = Product.find(params[:id]) loaded by CanCan
    @product.update_attributes(params[:product])
    respond_with(@product)
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    #@product = Product.find(params[:id]) loaded by CanCan
    @product.destroy
    respond_with(@product)
  end
end
