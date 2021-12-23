Rails.application.routes.draw do
  # Ways to make routes
  # 1) get '/articles', to: 'articles#index'
  # 2) resources :articles # By default, it creates ALL rules for CRUD actions. CRUD(create,read,update,destroy)
  resources :articles, only: [:index]  # By default, it creates rules for ONLY
end
