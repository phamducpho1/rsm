Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get "/signup", to: "registrations#new", as: :new_user_registration
    post "/signup", to: "registrations#create", as: :user_registration
    get "/profile", to: "registrations#edit", as: :edit_user_registration
    put "/signup", to: "registrations#update",as: nil
  end
  root "static_pages#index"
end
