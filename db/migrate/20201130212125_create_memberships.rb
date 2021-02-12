class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.date :startDate
      t.date :endDate

      t.timestamps
    end
  end
end
