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
        format.html { 
          if Import.picture_update.count > 0
            redirect_to :controller => 'settings', :action => 'follow_setting_update'
          else
            redirect_to admin_settings_url 
          end
        }
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

  def follow_setting_update
    #@imports is affect in before_filter
    respond_to do |format|
      format.html{
        redirect_to :action => 'index' if Import.picture_update.count < 1
      }
      format.js{render :layout => false}
    end
  end

end
