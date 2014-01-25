class AddSexToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :sex, :text
  end
end
