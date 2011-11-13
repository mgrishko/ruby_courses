class ProductsController < BaseController
  load_and_authorize_resource

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
    respond_with(@product)
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    #@product = Product.new loaded by CanCan
    respond_with(@product)
  end

  ## GET /products/1/edit
  #def edit
  #  @product = Product.find(params[:id])
  #end

  # POST /products
  # POST /products.xml
  def create
    #@product = Product.new(params[:product]) loaded by CanCan
    @product.save
    respond_with(@product)
  end

  ## PUT /products/1
  ## PUT /products/1.xml
  #def update
  #  @product = Product.find(params[:id])
  #  @product.update_attributes(params[:product])
  #  respond_with(@product)
  #end
  #
  ## DELETE /products/1
  ## DELETE /products/1.xml
  #def destroy
  #  @product = Product.find(params[:id])
  #  @product.destroy
  #  respond_with(@product)
  #end
end
