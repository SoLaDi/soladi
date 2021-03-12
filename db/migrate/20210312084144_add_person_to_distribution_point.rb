class AddPersonToDistributionPoint < ActiveRecord::Migration[6.0]
  def change
    change_table :distribution_points do |t|
      t.remove :contact_name
    end
    add_reference :distribution_points, :person, null: true, foreign_key: true
  end
end
