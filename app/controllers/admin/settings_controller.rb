class Admin::SettingsController < Admin::BaseController

  def index
    @page_title = 'Settings'
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
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

end
