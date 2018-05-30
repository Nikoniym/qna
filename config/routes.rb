Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy

  resources :questions do
    resources :answers, except: %i[index new show], shallow: true do
      put :set_best, on: :member
    end
  end
end
