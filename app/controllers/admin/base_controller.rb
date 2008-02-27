class Admin::BaseController < ApplicationController
  
  include AuthenticatedSystem
  layout "administration"
  
  before_filter :login_required 
end
