GoodsMaster::Application.routes.draw do
  constraints(subdomain: /.+/) do
    devise_for :users,
               path: "/",
               controllers: { registrations: 'users/registrations',
                              sessions: 'users/sessions',
                              invitations: 'users/invitations'},
               skip: [:registrations, :sessions, :invitations, :passwords] do

      # Routes signup and acknowledgement routes only under app subdomain
      constraints(subdomain: Settings.app_subdomain) do
        devise_for :users, controllers: { passwords: "users/passwords" },
          skip: [:registrations, :sessions, :invitations]
        get "/signup"  => "users/registrations#new",       as: :new_user_registration
        post "/signup" => "users/registrations#create",    as: :user_registration
        get "/signup/thankyou" => "users/registrations#acknowledgement", as: :signup_acknowledgement
      end

      # Routes edit user profile routes and sign in / sign out only under account subdomain
      # Todo: refactor to Subdomain class when will be more than one application subdomain
      constraints(lambda { |req| !(req.subdomain == Settings.app_subdomain) }) do
        get "/profile/edit" => "users/registrations#edit", as: :edit_user_registration
        put "/profile"  => "users/registrations#update"

        get '/signin'   => "users/sessions#new",        as: :new_user_session
        post '/signin'  => 'users/sessions#create',     as: :user_session
        get '/signout'  => 'users/sessions#destroy',    as: :destroy_user_session if Devise.sign_out_via == :get
        delete '/signout'  => 'users/sessions#destroy', as: :destroy_user_session

        get 'memberships/invitation/accept' => "users/invitations#edit",   as: :accept_user_invitation
        put 'memberships/invitation'        => "users/invitations#update", as: :user_invitation
      end
    end

    resource :account, only: [:edit, :update]
    resources :memberships, except: [:show, :new, :create]
    get 'memberships/invitation/new' => "memberships#new",    as: :new_membership
    post 'memberships/invitation'    => "memberships#create", as: :membership_invitation

    get '/products/:id/versions/:version' => "products#show", :as => :product_version
    resources :products do
      get 'autocomplete/:field' => "products#autocomplete", as: :autocomplete, on: :collection

      resources :comments, only: [:create, :destroy]
      resources :photos, only: [:create, :destroy]
    end

    # Admin dashboard is only under app subdomain
    constraints(subdomain: Settings.app_subdomain) do
      scope subdomain: Settings.app_subdomain do
        devise_for :admins, path: '/dashboard', controllers: { sessions: 'admin/sessions' }

        resources :admins, only: [:edit, :update], :module => "admin", :path => "dashboard/admins"

        namespace :admin, path: "/dashboard" do
          resources :accounts, only: [:index, :show] do
            get :activate, on: :member
            get :login_as_owner, on: :member
          end
          
          resources :events, only: :index

          get '/' => 'dashboard#index', as: :dashboard
          root :to => 'dashboard#index', as: :root
        end
      end
    end

    get '/'  => 'home#index', as: :home
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

