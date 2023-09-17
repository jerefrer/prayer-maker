Rails.application.routes.draw do
  resources :prayers do
    put :update_group
    put :insert_group
  end
  root 'prayers#index'
end