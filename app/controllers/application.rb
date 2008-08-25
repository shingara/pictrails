# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :secret => '9d6a74942666a6c164e479585234439c'
  
  before_filter :verify_config
  before_filter :update_size_picture
 

protected

  # Define the webapp by default. The first by Id
  def this_webapp
    @setting ||= Setting.default
  end

  helper_method :this_webapp

  # Verify if it's the first connection in
  # application
  def verify_config
    if User.count.zero?
      redirect_to admin_signup_url
    else
      true
    end
  end

  def update_size_picture
    if Import.picture_update.count > 0
      Import.limited(5).picture_update.each { |import| 
        import.update_size
        @import_picture_update_total = import.total
      }
      @import_picture_update_count = Import.picture_update.count
    end
  end

end
