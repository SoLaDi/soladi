# == Route Map
#

Rails.application.routes.draw do
  root to: 'home#index'
  resources :people do
    collection { post :import }
  end
  resources :distribution_points
  resources :bids do
    collection do
      post :import
      get :export_csv
    end
  end
  resources :transactions do
    collection do
      post :import
      get :export_csv
    end
  end
  resources :memberships do
    collection do
      post :send_bidding_invite_mail_to_all_memberships
      post :import
      get :export_csv
    end
    member do
      post :send_payment_overdue_reminder_mail
      post :send_bidding_invite_mail
    end
  end
  devise_for :users
  resources :users, only: [:show]

  namespace :api, defaults: { format: :json } do
    resources :magic_link, controller: 'magic_auth' do
      collection { get :login }
    end

    resources :bids, only: [:create]
  end
end
