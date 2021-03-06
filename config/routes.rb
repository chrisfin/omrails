Omrails::Application.routes.draw do
  resources :brands
  resources :pins
  resources :clicks
  resources :views
  resources :authentications
  resources :friends

  root :to => 'pins#index' 

  get "users/show"
  post "pages/authenticate"
  get "pages/allpins"
  get "pages/allusers"
  get "clicks/show"
  get "views/show"
  get "views/shop"
  post "pages/shop"
  get "pages/shop"
  get "pins/test"
  post "views/new_user_save"
  get "pages/create_admin"
  post "pins/create_view"
  get "pages/test"
  get "pages/twitter_test2"

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions", omniauth_callbacks: "authentications" }
  match 'users/:id' => 'users#show', as: :user


  get 'about' => 'pages#about'
  get 'control' => 'pages#control'
  get 'allpins' => 'pages#allpins'
  get 'menpins' => 'pages#menpins'
  get 'womenpins' => 'pages#womenpins'
  get 'allusers' => 'pages#allusers'
  get 'mobile' => 'pages#mobile'
  get 'pinterest' => 'pages#pinterest-1c237'

  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
