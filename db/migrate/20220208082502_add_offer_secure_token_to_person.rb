class AddOfferSecureTokenToPerson < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :offer_secure_token, :string
    add_index :people, :offer_secure_token, unique: true
  end
end
