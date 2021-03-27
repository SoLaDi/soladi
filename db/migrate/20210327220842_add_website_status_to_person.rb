class AddWebsiteStatusToPerson < ActiveRecord::Migration[6.0]
  def change
    change_table :people do |t|
      t.string :website_account_status
    end
  end
end
