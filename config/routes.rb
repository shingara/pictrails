ActionController::Routing::Routes.draw do |map|

  # View galleries in resources
  map.resources :galleries do |gallery|
    #resources of view picture of a gallery
    gallery.resources :pictures

    # Pagination of a page of all picture in a gallery
    gallery.connect 'page/:page',
      :controller => 'galleries', :action => 'show',
      :page => /\d+/
  end
    
  map.resources :pictures

  # route to the paginate of all galleries
  map.connect '/galleries/page/:page',
    :controller => 'galleries', :action => 'index',
    :page => /\d+/
  
  # route to the paginate of all pictures
  map.connect '/pictures/page/:page',
    :controller => 'pictures', :action => 'index',
    :page => /\d+/
  

  # Namespace of amdin
  map.namespace :admin do |admin|

    # Resources of users
    admin.resources :users

    #Resources of session
    admin.resource :session

    #Resources of picture
    admin.resources :pictures
    
    #Resources for settings
    admin.resources :settings 

    #Resources of gallerie
    admin.resources :galleries do |gallery|
      gallery.resources :pictures
    end

    admin.mass_upload '/galleries/mass_upload', :controller => 'galleries', :action => 'mass_upload'

    # particular route
    admin.login '/login', :controller => 'sessions', :action => 'new'
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.signup '/signup', :controller => 'users', :action => 'new'
    
    # Default page in this namespace
    admin.root :controller => 'galleries'
  end

  map.root :controller => 'galleries'
end
