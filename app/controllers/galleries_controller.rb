class GalleriesController < ApplicationController

  before_filter :verify_config
  
  
  caches_page :index, :show
  
  def index
    @galleries = Gallery.find_all_by_status true, :include => 'pictures'
    @page_title = 'List of Gallery' 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  def show
    begin
      @gallery = Gallery.find(params[:id], :include => 'pictures', :conditions => ["pictures.status = 't'"])
    rescue ActiveRecord::RecordNotFound
      @gallery = Gallery.find params[:id]
    end
    @page_title = "Gallery : #{@gallery.name}"
    unless @gallery.status
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
