class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :thread_id
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end
  end
end
