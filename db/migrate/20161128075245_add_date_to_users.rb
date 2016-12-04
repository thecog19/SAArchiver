class AddDateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reg_date, :string
  end
end
