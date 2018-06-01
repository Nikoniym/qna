Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy

  concern :rating do
    member do
      put :put_like
      put :put_dislike
      put :cancel_vote
    end
  end

  resources :questions, concerns: :rating do
    resources :answers, except: %i[index new show], concerns: :rating, shallow: true do
      put :set_best, on: :member
    end
  end
end
