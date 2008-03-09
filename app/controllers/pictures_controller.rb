class PicturesController < ApplicationController

  caches_page :index

  def index
    if params[:gallery_id]
      redirect_to gallery_url(Gallery.find_by_permalink(params[:gallery_id]))
    else
      @pictures = Picture.paginate :page => params[:page],
        :per_page => this_webapp.pictures_pagination
    end
  end

  def show
    @picture = Picture.find_by_permalink params[:id]
    raise ActiveRecord::RecordNotFound if @picture.nil?
  rescue ActiveRecord::RecordNotFound
    render :status => 404
  end

end
