class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
    	t.belongs_to :user
      t.belongs_to :pin
      t.timestamps
    end
  end
end
