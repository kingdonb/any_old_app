Rails.application.routes.draw do
  resources :indices
  root to: 'indices#index'
end
