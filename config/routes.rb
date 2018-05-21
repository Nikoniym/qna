Rails.application.routes.draw do
  resources :questions, except: :destroy do
    resources :answers, except: %i[index destroy], shallow: true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
