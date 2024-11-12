Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # 
  
  resource :signup

  resource :login

  resources :employees do
    resources :teams do
      get 'team_members', to: "teams#team_members_list"
      get 'team_member_detail', to: "teams#show_team_member_details"
    end
    get 'list_of_employee', to: "employees#list_available_employees"
  end

  resources :skills
end
