class AddTerminatedToMembership < ActiveRecord::Migration[6.0]
  def change
    add_column(:memberships, :terminated, :boolean, default: false, null: false)
    remove_column(:memberships, :startDate)
    remove_column(:memberships, :endDate)
  end
end
