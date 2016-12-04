class CreateSathreads < ActiveRecord::Migration[5.0]
  def change
    create_table :sathreads do |t|
      t.integer :op_id
      t.timestamps
    end
  end
end
