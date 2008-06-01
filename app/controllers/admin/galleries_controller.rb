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
        :per_page => 10
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
    render :status => 404 if @gallery.nil?
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

  # Method to add mass upload with only one params
  # the params define the directory where all picture are
  def mass_upload
    @gallery = Gallery.create_by_name_of_directory params[:directory]
    if File.directory? params[:directory]
      @gallery.save!
      @gallery.insert_pictures(params[:directory])
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
      format.js{
        # TODO: It's not really good. See how made better
        unless @imports.empty?
          render(:partial => 'admin/galleries/follow_import.html.erb')
        else
          render :text => '<script type="javascript">window.location.href = "/admin/galleries"</script>'
        end
      }
    end
  end
end
