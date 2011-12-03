class CommentsController < MainController
  load_resource :product, through: :current_account
  load_and_authorize_resource :comment, through: [:product]

  respond_to :html, :js

  # POST /comments
  # POST /comments.xml
  def create
    #@comment = Comment.new(params[:comment]) # loaded by cancan
    @comment.user = current_user
    @comment.save
    @comment = CommentDecorator.decorate(@comment)
    respond_with(@comment) do |format|
      format.html { redirect_to @product }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    #@comment = Comment.find(params[:id]) # loaded by cancan
    @comment.destroy
    respond_with(@comment) do |format|
      format.html { redirect_to @product }
    end
  end
end