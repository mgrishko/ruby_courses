GoodsMaster::Application.routes.draw do
  constraints(subdomain: /.+/) do

    devise_for :users,
               path: '/', controllers: {registrations: 'users/registrations'}, skip: [:registrations] do
      constraints(subdomain: "app") do
        get "/signup"  => "users/registrations#new",       as: :new_user_registration
        post "/signup" => "users/registrations#create",    as: :user_registration
        get "/signup/thankyou" => "users/registrations#acknowledgement", as: :signup_acknowledgement
      end

      get "/profile/edit" => "users/registrations#edit", as: :edit_user_registration
      put "/profile"  => "users/registrations#update"
      delete "/users" => "users/registrations#destroy"
      get "/users/cancel" => "users/registrations#cancel", as: :cancel_user_registration
    end

    constraints(subdomain: "app") do
      scope subdomain: "app", :path => "/dashboard" do
        devise_for :admins, path: '/'

        get '/' => 'admin/dashboard#index', as: :dashboard
        root :to => 'admin/dashboard#index', as: :admin_root
      end
    end

    get '/' => 'home#index', as: :home
    root :to => 'home#index', as: :root
  end

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
  # match ':controller(/:action(/:id(.:format)))'
end
