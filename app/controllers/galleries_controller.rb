class GalleriesController < ApplicationController

  before_filter :verify_config
  
  
  caches_page :index, :show
  
  def index
    @galleries = Gallery.paginate_by_status true, 
      :include => 'pictures', 
      :page => params[:page],
      :per_page => 3

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
      @pictures = Picture.paginate_by_gallery_id(@gallery.id,
                                                 :conditions => ["status = 't'"],
                                              :page => params[:page],
                                              :per_page => 3)
      respond_to do |format|
        format.html 
        format.xml  { render :xml => @gallery }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to galleries_url
  end

private

  def verify_config
    if User.count.zero?
      redirect_to admin_signup_url
    else
      true
    end
  end

end
