class AddStatusToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column(:transactions, :status, :string, default: "ok", null: false)
  end
end
