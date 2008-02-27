class Admin::GalleriesController < Admin::BaseController
  
  cache_sweeper :gallery_sweeper,  :only => [:create, :update, :destroy]

  def index
    @galleries = Gallery.find :all, :include => 'pictures'
    @page_title = 'List of Gallery'
  end

  # See a gallery in Admin like a User
  def show
    @gallery = Gallery.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render :status => 404
  end
  
  def new
    @gallery = Gallery.new
    # By default the status is online
    @gallery.status = true
    @page_title = "Create gallery"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end
  
  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
    @page_title = "edit #{@gallery.name}"
  rescue ActiveRecord::RecordNotFound
    render :status => 404
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to(admin_galleries_url) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'
        format.html { redirect_to admin_galleries_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    flash[:notice] = "The gallery #{@gallery.name} is deleted"

    respond_to do |format|
      format.html { redirect_to(admin_galleries_url) }
      format.xml  { head :ok }
    end
  end
end
