class Admin::CommentsController < Admin::BaseController

  # The index of comments view in admin
  def index
    @comments = Comment.paginate :all, :page => params[:page],
      :per_page => 20
  end

end
