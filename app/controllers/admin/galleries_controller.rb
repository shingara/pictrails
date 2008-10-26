class Admin::GalleriesController < Admin::BaseController
  
  cache_sweeper :gallery_sweeper,  :only => [:create, :update, :destroy, :mass_upload]

  def index
    @galleries = Gallery.find :all, :include => 'pictures'
    @page_title = 'List of Gallery'
  end

  # See a gallery in Admin like a User
  def show
    @gallery = Gallery.find_by_permalink params[:id]
    unless @gallery.nil?
      @pictures = Picture.paginate_by_gallery_id @gallery.id, :page => params[:page],
        :per_page => 12
    else
      render :status => 404
    end
  end
  
  def new
    @gallery = Gallery.new
    # By default the status is online
    @gallery.status = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end
  
  # GET /galleries/#{permalink}/edit
  def edit
    @gallery = Gallery.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound if @gallery.nil?
    @pictures = @gallery.pictures.paginate(:page => params[:page], :per_page => 20)
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
    @gallery = Gallery.find_by_permalink(params[:id])

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
    @gallery = Gallery.find_by_permalink(params[:id])
    @gallery.destroy
    flash[:notice] = "The gallery #{@gallery.name} is deleted"

    respond_to do |format|
      format.html { redirect_to(admin_galleries_url) }
      format.xml  { head :ok }
    end
  end

  # View the form to create gallery by mass_upload
  def new_by_mass_upload
  end

  # Method to add mass upload with only one params
  # the params define the directory where all picture are
  def mass_upload
    if Gallery.create_from_directory params[:directory]
      redirect_to :action => 'follow_import'
    else
      flash[:notice] = 'the directory is not a directory'
      render :action => 'new'
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  # See the following of mass_upload
  def follow_import
    #@imports is affect in before_filter
    respond_to do |format|
      format.html{redirect_to :action => 'index' if @imports.empty?}
      format.js{render :layout => false}
    end
  end


  # Search a picture by random in gallery
  # and return it
  def random_front_picture
    if request.xhr?
      @gallery = Gallery.find_by_permalink params[:id]
    else
      edit
    end
    @gallery.random_front_picture
    respond_to do |format|
      format.html {render :action => 'edit'}
      format.js {}
    end
  end

  # Define a picture like front picture to
  # a gallery
  # params are :
  #  * id : gallery_id
  #  * picture_id : the id of picture define like front
  # Redirect_to edit page where the new front picture is define and see
  def define_front
    gallery = Gallery.find params[:id]
    picture = Picture.find params[:picture_id]
    gallery.picture_default_id = params[:picture_id]
    if gallery.save
      flash[:notice] = "You have define the picture #{picture.title} like front of gallery #{gallery.name}"
    else
      flash[:notice] = "You can't define the picture #{picture.title} like front of gallery #{gallery.name}"
    end
    params[:page] = 1 if params[:page].blank?
    redirect_to edit_admin_gallery_url(gallery, :page => params[:page])
  end
end
