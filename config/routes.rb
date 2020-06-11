Rails.application.routes.draw do
  root 'apps#index'
  get 'about' => 'home#about'

  devise_for :users
  get 'users/:id/quit' => 'users#quit', as: 'quit_user'
  patch 'users/:id/cancel' => 'users#cancel', as: 'cancel_user'
  resources :users, only: [:show, :edit, :update]

  get 'apps/rate' => 'apps#rate_index', as: 'rate_apps'
  post 'apps/confirm' => 'apps#confirm', as: 'confirm_apps'
  get 'apps/:id/add_edit' => 'apps#add_edit', as: 'add_edit_app'
  patch 'apps/:id/add' => 'apps#add_update', as: 'add_update_app'
  get 'apps/:id/hint' => 'apps#hint', as: 'hint_app'
  get 'apps/:id/explanation' => 'apps#explanation', as: 'explanation_app'
  get 'apps/:id/hidden' => 'apps#hidden', as: 'hidden_app'
  patch 'apps/:id/cancel' => 'apps#cancel', as: 'cancel_app'
  resources :apps, only: [:new, :create, :show, :edit, :update] do
    resources :learnings, only: [:create, :show, :edit, :update]
    resources :questions, only: [:index, :create]
    resource :reviews, only: [:index]
  end

  get 'languages/:id/rate' => 'languages#rate_show', as: 'rate_language'
  resources :languages, only: [:show]
end
