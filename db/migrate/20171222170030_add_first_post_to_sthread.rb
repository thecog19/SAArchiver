class AddFirstPostToSthread < ActiveRecord::Migration[5.0]
  def change
    add_column :sathreads, :first_post_id, :integer
  end
end
