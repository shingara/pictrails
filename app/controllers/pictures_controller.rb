class PicturesController < ApplicationController

  caches_page :index, :show
  cache_sweeper :picture_sweeper

  # View the index of picture, there are All pictures with pagination
  def index
    if params[:gallery_id]
      redirect_to gallery_url(Gallery.find_by_permalink(params[:gallery_id]))
    else
      @pictures = Picture.paginate :page => params[:page],
        :per_page => this_webapp.pictures_pagination
    end

    respond_to do |format|
      format.html
    end
  end

  # View only one picture
  def show
    @picture = Picture.find_by_permalink params[:id]
    prepare_picture
    @comment = @picture.comments.new
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  def create_comment
    unless request.post?
      flash[:notice] = 'no comment save because GET request'
      redirect_to picture_url(Picture.find(params[:comment][:picture_id]))
      return
    end
    @comment = Comment.create(params[:comment])
    @comment.ip = request.remote_ip
    if @comment.save
      flash[:notice] = 'Your comment is save'
      redirect_to picture_url(@comment.picture) 
    else
      flash[:notice] = 'Your comment failed'
      @picture = Picture.find(params[:comment][:picture_id])
      prepare_picture
      render :action => 'show'
    end
  end

  private

  def prepare_picture
    raise ActiveRecord::RecordNotFound if @picture.nil?
    @gallery = @picture.gallery
    @tags = @picture.tag_list
    @breadcrumb = @picture
  end

end
