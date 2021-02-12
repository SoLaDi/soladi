class AddDistributionPointToMembership < ActiveRecord::Migration[6.0]
  def change
    add_reference :memberships, :distribution_point, null: false, foreign_key: true
  end
end
