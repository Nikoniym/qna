Rails.application.routes.draw do
  resources :questions, except: :destroy do
    resources :answers, except: :destroy
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
