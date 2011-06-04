Webforms::Application.routes.draw do
  namespace :admin do
    resources :users do
      resources :base_items
    end
    resources :base_items do
      resources :packaging_items
    end
    resources :packaging_items
    resources :gpcs
    resources :countries
  end

  resources :users
  match '/login' => 'user_sessions#login'
  match '/logout' => 'user_sessions#logout'

  match '/approve_emails' => 'base_items#approve_emails'

  resources :base_items do
    member do
      get 'accept'
      get 'reject'
      put 'published'
      put 'draft'
    end
    collection do
      get 'auto_complete_for_base_item_brand'
      get 'auto_complete_for_base_item_subbrand'
      get 'auto_complete_for_base_item_functional'
      get 'auto_complete_for_base_item_description'
      get 'auto_complete_for_base_item_manufacturer_gln'
      get 'auto_complete_for_base_item_manufacturer_name'
    end

    resources :packaging_items do
      member do
        get 'new_sub'
      end
    end
  end
  resources :retailer_attributes
  resources :user_attributes
  resources :comments
  resources :receivers
  resources :tags
  resources :subscription_results
  resources :subscription
  resources :suppliers

  root :to => 'base_items#index'

  match  'main/classifier' =>     'main#classifier', :as => :classifier
  match   'main/subgroups/:id' =>  'main#subgroups', :as => :subgroups
  match  'main/categories/:id' => 'main#categories', :as => :countries
  match   'main/countries' =>      'main#countries', :as => :countries
  match       'main/cases' =>          'main#cases', :as => :cases
  match    'main/show_man/:id' =>   'main#show_man', :as => :show_man


  match '/subscriptions/status' => 'subscription#status'
  match '/subscriptions/instantstatus' => 'subscription#instantstatus'

  match '/profiles/:id' => 'profiles#show'

  match ':controller(/:action(/:id(.:format)))'
end

