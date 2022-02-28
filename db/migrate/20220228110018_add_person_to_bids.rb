class AddPersonToBids < ActiveRecord::Migration[6.0]
  def change
    add_reference :bids, :person, null: true, foreign_key: true
  end
end
