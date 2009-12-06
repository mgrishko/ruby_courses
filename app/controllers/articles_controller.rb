class ArticlesController < ApplicationController
  before_filter :require_user
  @@model = Article

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    if params[:base].nil?
      @article = Article.new
    else
      @article = Article.find(params[:base].to_i)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    generate_attachment
    respond_to do |format|
      if @article.save
        if params[:publish] && @article.publish!
          flash[:notice] = 'Article was successfully created and sent'
        else
          flash[:notice] = 'Article was successfully created.'
        end
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  def publish
    @article = Article.find params[:id]
    generate_attachment
    @article.publish!
    redirect_to :action => 'index'
  end

  # GET /approve_emails
  #def approve_emails
    #@emails = Article.fetch_and_approve
  #end

  # GET /articles/auto_complete_for_record_value
  def auto_complete_for_record_value
    @items = Gpc.find_complete_values(params[:record][:value])

    render :inline => "<%= auto_complete_result(@items, 'name') %>"
  end

  private

  def generate_attachment
    f = File.new("#{RECORDS_OUT_DIR}/#{@article.id}.xml", 'w')
    f.write(render_to_string :template => 'articles/attachment.xml', :layout => false)
    f.close
  end

end
