# This controller handles the login/logout function of the site.  
class Admin::SessionsController < Admin::BaseController
  before_filter :login_required, :except => ['new', 'create']

  # render new.rhtml
  def new
    @page_title = "Connection"
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      redirect_back_or_default(admin_galleries_url)
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Login unsucessful"
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
