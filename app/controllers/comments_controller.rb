class CommentsController < MainController
  load_resource :product, through: :current_account
  load_and_authorize_resource :comment, through: [:product]

  respond_to :html, :js

  # POST /comments
  # POST /comments.xml
  def create
    #@comment = Comment.new(params[:comment]) # loaded by cancan
    @comment.user = current_user

    if @comment.save
      @comment.log_added(current_membership)
    end
    @comment = CommentDecorator.decorate(@comment)
    respond_with(@comment) do |format|
      format.html { redirect_to @product }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    #@comment = Comment.find(params[:id]) # loaded by cancan
    if @comment.destroy
      @comment.log_destroyed(current_membership)
    end
    respond_with(@comment) do |format|
      format.html { redirect_to @product }
    end
  end
end
