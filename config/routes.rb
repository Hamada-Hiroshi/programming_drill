Rails.application.routes.draw do
  get 'languages/show'
  get 'reviews/index'
  get 'questions/index'
  get 'questions/edit'
  get 'learnings/show'
  get 'learnings/edit'
  get 'apps/index'
  get 'apps/new'
  get 'apps/confirm'
  get 'apps/show'
  get 'apps/edit'
  get 'apps/add_edit'
  get 'apps/hint'
  get 'apps/explanation'
  get 'users/show'
  get 'users/edit'
  get 'users/quit'
  get 'home/about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
