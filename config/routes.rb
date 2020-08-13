Rails.application.routes.draw do
  root 'apps#index'
  get 'about' => 'home#about'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#new_guest'
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :quit
      patch :cancel
      get :following
      get :followers
      get :learnings
      get :stocks
    end
    resource :relationships, only: [:create, :destroy]
    resources :notifications, only: :index do
      delete :destroy_all, on: :collection
    end
  end

  resources :apps, only: [:index, :new, :create, :show, :edit, :update] do
    collection do
      post :confirm
      get :rate_index
      get :popular_index
      get :tag
      get :rate_tag
      get :popular_tag
    end
    member do
      get :hint
      get :explanation
      get :hint_edit
      get :explanation_edit
      patch :add_update
      get :hidden
      patch :cancel
    end
    resources :learnings, only: [:create, :show, :edit, :update]
    resources :questions, only: [:index, :create]
    resources :reviews, only: [:index, :create]
    resource :stocks, only: [:create, :destroy]
  end

  resources :langs, only: :show do
    member do
      get :rate_show
      get :popular_show
    end
  end

  devise_for :admins, skip: :all
  devise_scope :admin do
    get 'admin/sign_in' => 'admins/sessions#new', as: 'new_admin_session'
    post 'admin/sign_in' => 'admins/sessions#create', as: 'admin_session'
    delete 'admin/sign_out' => 'admins/sessions#destroy', as: 'destroy_admin_session'
    post 'admin/guest_sign_in' => 'admins/sessions#new_guest'
  end

  namespace :admin do
    root 'dashboards#index'
    resources :langs, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: :index do
      patch :cancel, on: :member
    end
    resources :apps, only: :index do
      patch :cancel, on: :member
    end
  end
end
