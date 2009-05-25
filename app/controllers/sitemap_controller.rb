class SitemapController < ApplicationController

  caches_page :index

  def index
    @galleries = Gallery.find(:all, :include => :pictures)
    @pictures = Picture.all
    @tags = Tag.all
    respond_to do |format|
      format.xml
    end
  end
end
