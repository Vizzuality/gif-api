Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "admin/dashboard#index"
  # Fake downloads
  get '/downloads/:id', to: 'downloads#download'

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources     :projects,                   only: [:index, :show, :create, :update]
      post          '/auth',                     to: 'authentication#authenticate'
      get           '/filters',                  to: 'filter_collections#index'
      get           '/projects/:id/related',     to: 'projects#related'
      match '*all' => 'authentication#cors',     via: :options
    end
  end
end
