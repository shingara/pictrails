# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :secret => '9d6a74942666a6c164e479585234439c'
 

protected

  # Define the webapp by default. The first by Id
  def this_webapp
    @setting ||= Setting.default
  end

  helper_method :this_webapp

end
