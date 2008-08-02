class PicturesController < ApplicationController

  caches_page :index, :show

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
    @gallery = @picture.gallery
    @tags = @picture.tag_list
    @breadcrumb = @picture
    raise ActiveRecord::RecordNotFound if @picture.nil?
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

end
