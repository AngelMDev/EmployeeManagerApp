Rails.application.routes.draw do
  root to: 'sessions#index'
  resources :companies, only: [:index, :show], param: :name, path: '' do
    resources :departments, only: [:index, :show], param: :department_name
    resources :employees, except: [:edit, :new, :update] do
      member do
        get 'edit_information', to: 'employees#edit_information'
        get 'edit_compensation', to: 'employees#edit_compensation'
        patch 'update_information', to: 'employees#update_information'
        patch 'update_compensation', to: 'employees#update_compensation'
      end
    end
  end
  post 'login', to: 'sessions#login'
  post 'logout', to: 'sessions#logout'
end
