class Admin::UsersController < Admin::BaseController

  before_filter :verify_users
  before_filter :login_required, :except => ['new', 'create']
  
  # render new.rhtml
  def new
    @page_title = "Create user"
  end

  def create
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default(admin_galleries_url)
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

private

  def verify_users
    unless User.count.zero?
      if logged_in?
        redirect_to admin_galleries_url
      else
        redirect_to admin_login_url
      end
    else
      true
    end
  end

end
