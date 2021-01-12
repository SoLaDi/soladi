class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.integer :shares
      t.date :startDate
      t.date :endDate
      t.string :distributionPoint

      t.timestamps
    end
  end
end
