class AddIndexToBid < ActiveRecord::Migration[6.0]
  def change
    change_table :bids do |t|
      t.index [:start_date, :end_date, :membership_id], unique: true, name: 'bids_unique'
    end
  end
end
