class CreateDistributionPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :distribution_points do |t|
      t.string :name
      t.string :street
      t.string :housenumber
      t.string :zipcode
      t.string :city
      t.integer :contact_name

      t.timestamps
    end
  end
end
