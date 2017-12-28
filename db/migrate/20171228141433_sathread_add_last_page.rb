class SathreadAddLastPage < ActiveRecord::Migration[5.0]
  def change
  	add_column :sathreads, :last_page, :string
  end
end
