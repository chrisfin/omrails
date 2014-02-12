class AddSextoPins < ActiveRecord::Migration
  def up
  	add_column :pins, :sex, :text
  end

  def down
  end
end
