ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session

  map.resources :messages

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
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
