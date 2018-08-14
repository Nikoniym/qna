require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_scope :user do
    get 'new_email' => 'omniauth_callbacks#new_email'
    post 'create_user', to: 'omniauth_callbacks#create_user'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', confirmations: 'confirmations' }

  root to: 'questions#index'

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create]
      end
    end
  end

  concern :rating do
    member do
      put :like
      put :dislike
      put :cancel_vote
    end
  end

  concern :comment do
    get :new_comment
  end

  resources :comments, only: :create

  resources :questions, concerns: [:rating, :comment] do
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :answers, except: %i[index new show], concerns: [:rating, :comment], shallow: true do
      put :set_best, on: :member
    end
  end

  resources :search, only: :index
end
