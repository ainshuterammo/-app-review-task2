Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root to: 'homes#top'
  get "home/about"=>"homes#about", as: "about"

  resources :books, only: [:new, :index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resources :relationships, only: [:create, :destroy]
    get :followers, on: :member
    get :followeds, on: :member
    # resource :relationships, only: [:create, :destroy]
    # get 'followers' => 'relationships#followers', as: 'followers'
    # get 'followeds' => 'relationships#followeds', as: 'followeds'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end