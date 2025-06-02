Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :artworks do
    member {get :view}
    collection {get :browse, :recent}
  end
  resources :techniques do
    member {
      get :view
      get :browse
    }
  end
  resources :categories do
    member {
      get :view
      get :browse
    }
  end
  
  resources :studies do
    member {get :view}
  end
  
  resources :menu_items do
    collection {get :browse}
  end
  
  resources :pages do
    member {get :view}
  end
  get "/p/:slug" => "pages#view"  
  
  resources :images do
    member {get :view}
  end
  
  resources :messages do
    member {
      put "mark_read" => "messages#mark_read"
      put "mark_unread" => "messages#mark_unread"
    }
  end
  
  
  resources :slides do
    collection {
        post :sort
        get :browse
    }
  end

  get "home/index"
  get "home/regenerate"
  get "home/report"
  get "home/export"

  get "contact" => "messages#new", :as => "contact"
  # get "logout" => "sessions#destroy", :as => "logout" # Replaced by Devise
  # get "login" => "sessions#new", :as => "login" # Replaced by Devise
  # get "signup" => "users#new", :as => "signup" # Replaced by Devise
  resources :users # Replaced by Devise
  # resources :sessions # Replaced by Devise
  get "admin" => "home#index", :as => "home"
  get "intro" => "slides#browse"
  root :to => "slides#browse"
  
  
  #fix compass-twitter-bootstrap img routing problems
  get "/img/:filename.:filetype" => redirect("/assets/%{filename}.%{filetype}")
end
