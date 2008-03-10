class Admin::SettingsController < Admin::BaseController
  
  cache_sweeper :setting_sweeper,  :only => [:update]

  # View form of settings
  def index
  end

  # Update the settings
  def update
    respond_to do |format|
      if this_webapp.update_attributes(params[:setting])
        flash[:notice] = 'Settings was successfully updated.'
        format.html { redirect_to admin_settings_url }
      else
        format.html { render :action => "index" }
      end
    end
  end

  #This method delete all page in cache
  def delete_cache
    PageCache.sweep_all
    flash[:notice] = 'All cache is deleted'
    redirect_to :action => 'index'
  end

end
