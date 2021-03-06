ActionController::Routing::Routes.draw do |map|

  # root path
  map.root :controller => 'messages'

  # user registration routes
  map.with_options :controller => 'users' do |user|
    user.signup '/signup', :action => 'new'
    user.register '/register', :action => 'create'
    user.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil
  end

  # login and logout routes
  map.resource :session, :only => [:create, :new]
  map.with_options :controller => 'sessions' do |session|
    session.login  '/login', :action => 'new'
    session.logout '/logout', :action => 'destroy'
  end

  map.resources :messages
  map.resources :private_messages, :only => [:index, :create, :destroy]
  map.resources :invitations, :only => [:index, :create]
  map.invitation '/invitations/:invitation_code', :controller => 'invitations', :invitation_code => nil

  map.user_messages '/:user_id/messages', :controller => 'messages', :action => 'create', :conditions => { :method => :post }  
  map.resources :users, :only => [:index], :collection => { :suggested => :get } do |users|
     users.resources :contacts, :path_prefix => ":user_id", :only => [:index, :create], :collection => { :remove => :delete }
     users.resources :favorites, :path_prefix => ":user_id", :only => [:index, :create, :destroy]
  end

  map.page '/pages/:permalink', :controller => 'pages', :action => 'show'
  map.with_options :controller => 'users' do |users|
    users.user '/:id', :action => 'show', :conditions => { :method => :get }
    users.edit_account '/account/settings', :action => 'edit', :conditions => { :method => :get }
    users.update_account '/account/update', :action => 'update', :conditions => { :method => :put }
    users.update_password '/account/password', :action => 'update_password', :conditions => { :method => :put }
    users.update_notices '/account/notices', :action => 'update_notices', :conditions => { :method => :put }
    users.update_picture '/account/picture', :action => 'update_picture', :conditions => { :method => :put }
  end

  #resource route within a admin namespace:
  map.namespace :admin do |admin|
    admin.root :controller => :dashboard
    admin.resources :dashboard
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
#== Route Map
# Generated on 09 Jun 2009 15:15
#
#       logout        /logout                            {:controller=>"sessions", :action=>"destroy"}
#        login        /login                             {:controller=>"sessions", :action=>"new"}
#     register        /register                          {:controller=>"users", :action=>"create"}
#       signup        /signup                            {:controller=>"users", :action=>"new"}
#        users GET    /users(.:format)                   {:controller=>"users", :action=>"index"}
#              POST   /users(.:format)                   {:controller=>"users", :action=>"create"}
#     new_user GET    /users/new(.:format)               {:controller=>"users", :action=>"new"}
#    edit_user GET    /users/:id/edit(.:format)          {:controller=>"users", :action=>"edit"}
#         user GET    /users/:id(.:format)               {:controller=>"users", :action=>"show"}
#              PUT    /users/:id(.:format)               {:controller=>"users", :action=>"update"}
#              DELETE /users/:id(.:format)               {:controller=>"users", :action=>"destroy"}
#  new_session GET    /session/new(.:format)             {:controller=>"sessions", :action=>"new"}
# edit_session GET    /session/edit(.:format)            {:controller=>"sessions", :action=>"edit"}
#      session GET    /session(.:format)                 {:controller=>"sessions", :action=>"show"}
#              PUT    /session(.:format)                 {:controller=>"sessions", :action=>"update"}
#              DELETE /session(.:format)                 {:controller=>"sessions", :action=>"destroy"}
#              POST   /session(.:format)                 {:controller=>"sessions", :action=>"create"}
#     messages GET    /messages(.:format)                {:controller=>"messages", :action=>"index"}
#              POST   /messages(.:format)                {:controller=>"messages", :action=>"create"}
#  new_message GET    /messages/new(.:format)            {:controller=>"messages", :action=>"new"}
# edit_message GET    /messages/:id/edit(.:format)       {:controller=>"messages", :action=>"edit"}
#      message GET    /messages/:id(.:format)            {:controller=>"messages", :action=>"show"}
#              PUT    /messages/:id(.:format)            {:controller=>"messages", :action=>"update"}
#              DELETE /messages/:id(.:format)            {:controller=>"messages", :action=>"destroy"}
#                     /:controller/:action/:id           
#                     /:controller/:action/:id(.:format) 
