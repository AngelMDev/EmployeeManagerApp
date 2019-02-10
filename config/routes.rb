Rails.application.routes.draw do
  root to: 'companies#index'
  resources :companies, only: [:index, :show], param: :name, path: '' do
    get 'employees', to: 'employees#master_index'
    resources :departments, only: [:index, :show], param: :name do
      resources :employees, except: [:edit, :new, :update] do
        member do
          get 'edit_information', to: 'employees#edit_information'
          get 'edit_compensation', to: 'employees#edit_compensation'
          put 'update_information', to: 'employees#update_information'
          put 'update_compensation', to: 'employees#update_compensation'
        end
      end
    end
  end
end
