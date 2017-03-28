Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :projects, only: [:index, :show]
    end
  end
end
