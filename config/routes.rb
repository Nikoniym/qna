Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'questions#index'

  resources :attachments, only: :destroy

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
