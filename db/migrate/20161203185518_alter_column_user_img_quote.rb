class AlterColumnUserImgQuote < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.change :image, :text
      t.change :quote, :text
    end
  end
end
