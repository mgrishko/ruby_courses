GoodsMaster::Application.routes.draw do
  constraints(subdomain: /.+/) do
    devise_for :users, path: "/",
               controllers: { registrations: 'users/registrations',
                              sessions: 'users/sessions',
                              invitations: 'users/invitations'},
               skip: [:registrations, :sessions, :invitations, :passwords]

      devise_scope :user do
        # Sign in/out works global wide.
        get '/signin'   => "users/sessions#new",        as: :new_user_session
        post '/signin'  => 'users/sessions#create',     as: :user_session
        get '/signout'  => 'users/sessions#destroy',    as: :destroy_user_session if Devise.sign_out_via == :get
        delete '/signout'  => 'users/sessions#destroy', as: :destroy_user_session


        # Routes signup and acknowledgement routes only under app subdomain
        constraints(subdomain: Settings.app_subdomain) do
          devise_for :users, controllers: { passwords: "users/passwords" },
            skip: [:registrations, :sessions, :invitations]
          get "/signup"  => "users/registrations#new",       as: :new_user_registration
          post "/signup" => "users/registrations#create",    as: :user_registration
          get "/signup/thankyou" => "users/registrations#acknowledgement", as: :signup_acknowledgement
        end

        # Todo: refactor to Subdomain class when will be more than one application subdomain
        constraints(lambda { |req| !(req.subdomain == Settings.app_subdomain) }) do
          get "/profile/edit" => "users/registrations#edit", as: :edit_user_registration
          put "/profile"  => "users/registrations#update"

          get 'memberships/invitation/accept' => "users/invitations#edit",   as: :accept_user_invitation
          put 'memberships/invitation'        => "users/invitations#update", as: :user_invitation
        end
      end

    # Within accounts subdomains
    constraints(lambda { |req| !(req.subdomain == Settings.app_subdomain) }) do
      resource :account, only: [:edit, :update]
      resources :memberships, except: [:show, :new, :create]
      get 'memberships/invitation/new' => "memberships#new",    as: :new_membership
      post 'memberships/invitation'    => "memberships#create", as: :membership_invitation

      get '/products/:id/versions/:version' => "products#show", :as => :product_version
      resources :products do
        get 'autocomplete/:field' => "products#autocomplete", as: :autocomplete, on: :collection

        resources :comments, only: [:create, :destroy]
        resources :photos, only: [:show, :create, :destroy]
      end
    end

    # Within app subdomain
    constraints(subdomain: Settings.app_subdomain) do
      namespace :users, path: "/signup" do
        resource :account, only: [:new, :create]
      end

      namespace :users, path: "/signin" do
        resources :accounts, only: :index
      end

      scope subdomain: Settings.app_subdomain do
        devise_for :admins, path: 'dashboard', controllers: { sessions: 'admin/sessions' }, format: false

        resources :admins, only: [:edit, :update], :module => "admin", :path => "dashboard/admins"

        namespace :admin, path: "dashboard" do
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
end

