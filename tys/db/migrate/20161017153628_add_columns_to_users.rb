class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secondary_email, :string
    add_column :users, :phone, :string
  end
end
