Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :projects, only: [:index, :show]
    end
  end
end
