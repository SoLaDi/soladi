class AddLoginTokenToPerson < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :login_token, :string
    add_index :people, :login_token, unique: true
  end
end
