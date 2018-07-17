Rails.application.routes.draw do
  devise_scope :user do
    get 'new_email' => 'omniauth_callbacks#new_email'
    post 'create_user', to: 'omniauth_callbacks#create_user'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', confirmations: 'confirmations' }

  root to: 'questions#index'

  resources :attachments, only: :destroy

  # get 'new_email', to: 'omniauth_callbacks#new_email'

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
    resources :answers, except: %i[index new show], concerns: [:rating, :comment], shallow: true do
      put :set_best, on: :member
    end
  end
end
