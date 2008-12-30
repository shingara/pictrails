ActionController::Routing::Routes.draw do |map|

  # View galleries in resources
  map.resources :galleries do |gallery|
    #resources of view picture of a gallery
    gallery.resources :pictures do |pic|
      #pic.connect 'page/:page', :controller => 'pictures', :action => 'show', :page => /\d+/
    end
    #gallery.connect 'page/:page', :controller => 'galleries', :action => 'show', :page => /\d+/
  end

  #Pagination of galleries
  map.connect '/galleries/:id/page/:page', :controller => 'galleries', :action => 'show', :page => /\d+/
  map.connect '/galleries/:gallery_id/pictures/:id/page/:page', :controller => 'pictures', :action => 'show', :page => /\d+/
    
  map.connect '/pictures/:year', :controller => 'pictures',
                                  :action => 'find_by_date',
                                  :year => /\d{4}/

  map.connect '/pictures/:year/:month', :controller => 'pictures',
                                        :action => 'find_by_date',
                                        :year => /\d{4}/,
                                        :month => /\d{2}/

  map.connect '/pictures/:year/:month/:day', :controller => 'pictures',
                                              :action => 'find_by_date',
                                              :year => /\d{4}/,
                                              :month => /\d{2}/,
                                              :day => /\d{1,2}/

  map.resources :pictures, :collection => {:create_comment => :post}

  map.resources :tags

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
    admin.resources :comments
    #pagination of pictures
    admin.connect '/pictures/page/:page', :controller => 'pictures',
        :action => 'index', :page => /\d+/
    
    #Resources for settings
    admin.resources :settings , :collection => { :delete_cache => :any, :follow_setting_update => :any} 
    
    #Resources of gallerie
    admin.resources :galleries , :collection => {:random_front_picture => :any, :new_by_mass_upload => :any, :mass_upload => :any, 
      :follow_import => :any, :define_front => :post} do |gallery|
      gallery.resources :pictures do |gallery_pic|
        gallery_pic.connect 'copy', :controller => 'pictures', :action => 'copy'
      end
      gallery.connect 'page/:page', :controller => 'galleries', :action => 'show', :page => /\d+/
    end

    # particular route
    admin.login '/login', :controller => 'sessions', :action => 'new'
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.signup '/signup', :controller => 'users', :action => 'new'
    
    # Default page in this namespace
    admin.root :controller => 'galleries'

  end

  map.root :controller => 'galleries'
  map.sitemap '/sitemap.xml', :controller => 'sitemap', :action => 'index'
end
