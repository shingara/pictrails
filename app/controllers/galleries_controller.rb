class GalleriesController < ApplicationController

  caches_page :index, :show
  
  def index
    @galleries = Gallery.paginate_by_status_and_parent_id true, nil,
      :include => 'pictures', 
      :page => params[:page],
      :per_page => this_webapp.galleries_pagination

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  def show
    @gallery = Gallery.find_by_permalink(params[:id]) 
    raise ActiveRecord::RecordNotFound if @gallery.nil?
    unless  @gallery.status
      redirect_to galleries_url
    else
      @pictures = Picture.paginate_by_gallery_id_and_status(@gallery.id, true,
                                              :include => 'gallery',
                                              :page => params[:page],
                                              :per_page => this_webapp.pictures_pagination)
      @sub_galleries = Gallery.find_by_parent_id @gallery.id
      @sub_galleries = [@sub_galleries] unless @sub_galleries.is_a? Array
      respond_to do |format|
        format.html 
        format.xml  { render :xml => @gallery }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :status => 404
  end

end
