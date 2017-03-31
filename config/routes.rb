Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :projects, only: [:index, :show]
      get '/filters', to: 'filter_collections#index'
    end
  end
end
