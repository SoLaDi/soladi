class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.integer :shares
      t.datetime :startDate
      t.datetime :endDate
      t.string :distributionPoint

      t.timestamps
    end
  end
end
