class ProductsController < MainController
  include AutoComplete::Action
  respond_to :html, :js
  respond_to :json, only: :autocomplete

  load_and_authorize_resource :through => :current_account
  before_filter :prepare_comment, except: [:index, :destroy, :autocomplete]
  before_filter :prepare_photo, only: [:show, :edit, :update]
  after_filter :log_event, only: [:create, :update, :destroy]
  before_filter :load_version, only: [:show]
  before_filter :sanitize_params, only: :index

  has_scope :by_brand, only: :index
  has_scope :by_manufacturer, only: :index
  has_scope :by_tags_name, as: :by_tag, only: :index
  has_scope :by_functional_name, as: :by_functional, only: :index

  # GET /products
  # GET /products.xml
  def index
    #@products = Product.all loaded by CanCan
    @products = ProductDecorator.decorate(apply_scopes(@products).
                                              asc(group_by).
                                              limit(Settings.products.limit).
                                              offset(params[:offset].to_i))
    respond_with(@products)
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    #@product = Product.find(params[:id]) loaded by CanCan
    @comments = CommentDecorator.decorate(@product.comments.asc(:created_at))
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

  # Sanitizes params for index action.
  def sanitize_params
    # Sanitizing :group_by param
    allowed_groups = Settings.products.group_options.split(/\s/)
    params.delete(:group_by) unless params[:group_by].blank? || allowed_groups.include?(params[:group_by])

    # Sanitizing scopes
    # Returning allowed scopes array: [:by_brand, :by_manufacturer, :by_tag, :by_functional]
    allowed_scopes = self.scopes_configuration.values.map{ |v| v[:as] }
    scopes = params.keys.reject{ |k| %w(controller action group_by offset).include?(k.to_s) }
    scopes.each do |scope|
      params.delete(scope) unless allowed_scopes.include?(scope.to_sym)
    end
  end

  # Returns group_by option.
  # Default options is :functional_name.
  #
  # @return [String] group by option
  def group_by
    @group_by = params[:group_by] || Settings.products.default_group
  end

  # Prepares comment for show, new and edit actions.
  def prepare_comment
    @comment = @product.prepare_comment(current_user, params[:comment])
  end
  
  # Logs created, updated, destroyed events of a product. On create and update
  # binds the system comment to the event
  def log_event
    return unless @product.errors.empty?

    event = @product.log_event(action_name)
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
