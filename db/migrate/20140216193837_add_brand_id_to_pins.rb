class AddBrandIdToPins < ActiveRecord::Migration
  def change
  	add_column :pins, :brand_id, :integer
  end
end
