class AddLastPostToThread < ActiveRecord::Migration[5.0]
  def change
    add_column :sathreads, :last_post_id, :integer
  end
end
