class Admin::BaseController < ApplicationController
  
  include AuthenticatedSystem
  include Pictrails::MassUpload
  layout "administration"
  
  before_filter :login_required 

  # This filter is use too with a user not logged.
  # Why don't help to import all picture :p
  before_filter :upload_file
end
