# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                          transactions GET    /transactions(.:format)                                                                  transactions#index
#                                       POST   /transactions(.:format)                                                                  transactions#create
#                       new_transaction GET    /transactions/new(.:format)                                                              transactions#new
#                      edit_transaction GET    /transactions/:id/edit(.:format)                                                         transactions#edit
#                           transaction GET    /transactions/:id(.:format)                                                              transactions#show
#                                       PATCH  /transactions/:id(.:format)                                                              transactions#update
#                                       PUT    /transactions/:id(.:format)                                                              transactions#update
#                                       DELETE /transactions/:id(.:format)                                                              transactions#destroy
#                           memberships GET    /memberships(.:format)                                                                   memberships#index
#                                       POST   /memberships(.:format)                                                                   memberships#create
#                        new_membership GET    /memberships/new(.:format)                                                               memberships#new
#                       edit_membership GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                            membership GET    /memberships/:id(.:format)                                                               memberships#show
#                                       PATCH  /memberships/:id(.:format)                                                               memberships#update
#                                       PUT    /memberships/:id(.:format)                                                               memberships#update
#                                       DELETE /memberships/:id(.:format)                                                               memberships#destroy
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#   rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#health_check
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  resources :payments do collection {post :generate} end
  root :to => 'home#index'
  devise_for :admins
  devise_for :users
  resources :transactions do collection {post :import} end
  resources :memberships
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end