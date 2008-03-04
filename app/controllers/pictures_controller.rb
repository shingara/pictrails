class PicturesController < ApplicationController

  caches_page :index

  def index
    if params[:gallery_id]
      redirect_to gallery_url(Gallery.find_by_permalink(params[:gallery_id]))
    else
      @pictures = Picture.paginate :page => params[:page],
        :per_page => 3
    end
  end

  def show
  end

end
