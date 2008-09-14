class Admin::CommentsController < Admin::BaseController

  # The index of comments view in admin
  def index
    @comments = Comment.paginate :all, :page => params[:page],
      :per_page => 20
  end

  # See a comment specific with params[:id].
  # If no comment, render a 404
  def show
    @comment = Comment.find params[:id]
  end

  def destroy
    unless request.delete?
      flash[:notice] = "you can't destroy a comment by get request"
      redirect_to admin_comments_url
      return
    end
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:notice] = "Comment #{comment.id} is destroy"
    redirect_to admin_comments_url
  end

  # View the edit page of comment
  def edit
    @comment = Comment.find params[:id]
  end

  def update
    unless request.put?
      flash[:notice] = "you can't update a comment by get request"
      redirect_to admin_comments_url
      return
    end
    @comment = Comment.find params[:id]
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment is update"
      redirect_to admin_comments_url
    else
      render :action => 'edit'
    end
  end

end
