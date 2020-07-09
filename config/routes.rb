Rails.application.routes.draw do
  root 'apps#index'
  get 'about' => 'home#about'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#new_guest'
  end
  get 'users/:id/quit' => 'users#quit', as: 'quit_user'
  patch 'users/:id/cancel' => 'users#cancel', as: 'cancel_user'
  resources :users, only: [:show, :edit, :update]

  get 'apps/rate' => 'apps#rate_index', as: 'rate_apps'
  get 'apps/popular' => 'apps#popular_index', as: 'popular_apps'
  get 'apps/tag' => 'apps#tag', as: 'tag_apps'
  get 'apps/tag/rate' => 'apps#rate_tag', as: 'rate_tag_apps'
  get 'apps/tag/popular' => 'apps#popular_tag', as: 'popular_tag_apps'
  post 'apps/confirm' => 'apps#confirm', as: 'confirm_apps'
  get 'apps/:id/add_edit' => 'apps#add_edit', as: 'add_edit_app'
  patch 'apps/:id/add' => 'apps#add_update', as: 'add_update_app'
  get 'apps/:id/hint' => 'apps#hint', as: 'hint_app'
  get 'apps/:id/explanation' => 'apps#explanation', as: 'explanation_app'
  get 'apps/:id/hidden' => 'apps#hidden', as: 'hidden_app'
  patch 'apps/:id/cancel' => 'apps#cancel', as: 'cancel_app'
  resources :apps, only: [:index, :new, :create, :show, :edit, :update] do
    resources :learnings, only: [:create, :show, :update]
    resources :questions, only: [:index, :create]
    resources :reviews, only: [:index, :create]
  end

  get 'langs/:id/rate' => 'langs#rate_show', as: 'rate_lang'
  get 'langs/:id/popular' => 'langs#popular_show', as: 'popular_lang'
  resources :langs, only: [:show]

  devise_for :admins, skip: :all
  devise_scope :admin do
    get 'admin/sign_in' => 'admins/sessions#new', as: 'new_admin_session'
    post 'admin/sign_in' => 'admins/sessions#create', as: 'admin_session'
    delete 'admin/sign_out' => 'admins/sessions#destroy', as: 'destroy_admin_session'
    post 'admin/guest_sign_in' => 'admins/sessions#new_guest'
  end
  namespace :admin do
    root 'langs#index'
    resources :langs, only: [:show, :create, :update, :destroy]
  end
end
