# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#                      root GET    /                                                                                        home#index
#                    people GET    /people(.:format)                                                                        people#index
#                           POST   /people(.:format)                                                                        people#create
#                new_person GET    /people/new(.:format)                                                                    people#new
#               edit_person GET    /people/:id/edit(.:format)                                                               people#edit
#                    person GET    /people/:id(.:format)                                                                    people#show
#                           PATCH  /people/:id(.:format)                                                                    people#update
#                           PUT    /people/:id(.:format)                                                                    people#update
#                           DELETE /people/:id(.:format)                                                                    people#destroy
#       distribution_points GET    /distribution_points(.:format)                                                           distribution_points#index
#                           POST   /distribution_points(.:format)                                                           distribution_points#create
#    new_distribution_point GET    /distribution_points/new(.:format)                                                       distribution_points#new
#   edit_distribution_point GET    /distribution_points/:id/edit(.:format)                                                  distribution_points#edit
#        distribution_point GET    /distribution_points/:id(.:format)                                                       distribution_points#show
#                           PATCH  /distribution_points/:id(.:format)                                                       distribution_points#update
#                           PUT    /distribution_points/:id(.:format)                                                       distribution_points#update
#                           DELETE /distribution_points/:id(.:format)                                                       distribution_points#destroy
#               import_bids POST   /bids/import(.:format)                                                                   bids#import
#                      bids GET    /bids(.:format)                                                                          bids#index
#                           POST   /bids(.:format)                                                                          bids#create
#                   new_bid GET    /bids/new(.:format)                                                                      bids#new
#                  edit_bid GET    /bids/:id/edit(.:format)                                                                 bids#edit
#                       bid GET    /bids/:id(.:format)                                                                      bids#show
#                           PATCH  /bids/:id(.:format)                                                                      bids#update
#                           PUT    /bids/:id(.:format)                                                                      bids#update
#                           DELETE /bids/:id(.:format)                                                                      bids#destroy
#       import_transactions POST   /transactions/import(.:format)                                                           transactions#import
#              transactions GET    /transactions(.:format)                                                                  transactions#index
#                           POST   /transactions(.:format)                                                                  transactions#create
#           new_transaction GET    /transactions/new(.:format)                                                              transactions#new
#          edit_transaction GET    /transactions/:id/edit(.:format)                                                         transactions#edit
#               transaction GET    /transactions/:id(.:format)                                                              transactions#show
#                           PATCH  /transactions/:id(.:format)                                                              transactions#update
#                           PUT    /transactions/:id(.:format)                                                              transactions#update
#                           DELETE /transactions/:id(.:format)                                                              transactions#destroy
#        import_memberships POST   /memberships/import(.:format)                                                            memberships#import
#               memberships GET    /memberships(.:format)                                                                   memberships#index
#                           POST   /memberships(.:format)                                                                   memberships#create
#            new_membership GET    /memberships/new(.:format)                                                               memberships#new
#           edit_membership GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                membership GET    /memberships/:id(.:format)                                                               memberships#show
#                           PATCH  /memberships/:id(.:format)                                                               memberships#update
#                           PUT    /memberships/:id(.:format)                                                               memberships#update
#                           DELETE /memberships/:id(.:format)                                                               memberships#destroy
#          new_user_session GET    /users/sign_in(.:format)                                                                 devise/sessions#new
#              user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
#      destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
#           new_user_unlock GET    /users/unlock/new(.:format)                                                              devise/unlocks#new
#               user_unlock GET    /users/unlock(.:format)                                                                  devise/unlocks#show
#                           POST   /users/unlock(.:format)                                                                  devise/unlocks#create
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  root :to => 'home#index'
  resources :people do
    collection { post :import }
  end
  resources :distribution_points
  resources :bids do
    collection { post :import }
  end
  resources :transactions do
    collection {
      post :import
      get :export_csv
    }
  end
  resources :memberships do
    collection {
      post :send_payment_overdue_reminder_mails
      post :import
    }
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
