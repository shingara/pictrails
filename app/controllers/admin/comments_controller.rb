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

end
