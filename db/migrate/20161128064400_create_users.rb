class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.text :quote
      t.integer :user_id 
      t.timestamps
    end
  end
end
