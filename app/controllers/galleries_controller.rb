class GalleriesController < ApplicationController

  before_filter :verify_config
  
  
  caches_page :index, :show
  
  def index
    @galleries = Gallery.find_all_by_status true, :include => 'pictures'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  def show
    @gallery = Gallery.find_by_permalink(params[:id], :include => 'pictures', :conditions => ["pictures.status = 't'"])
    # find_by_permalink return nil not raise ActiveRecord::RecordNotFound,
    # there are a gallery, but they haven't picture
    @gallery = Gallery.find_by_permalink params[:id] if @gallery.nil?
    raise ActiveRecord::RecordNotFound if @gallery.nil?
    unless  @gallery.status
      redirect_to galleries_url
    else
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
