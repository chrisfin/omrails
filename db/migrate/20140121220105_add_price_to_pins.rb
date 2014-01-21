class AddPriceToPins < ActiveRecord::Migration
  def change
  	add_column :pins, :price, :float
  	add_column :pins, :product_url, :text
  end
end
