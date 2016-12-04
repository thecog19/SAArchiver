class AddThreadIdToThreads < ActiveRecord::Migration[5.0]
  def change
    add_column :sathreads, :thread_id, :integer
  end
end
