class SathreadAddThreadTitle < ActiveRecord::Migration[5.0]
  def change
  	add_column :sathreads, :title, :string
  end
end
