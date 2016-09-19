class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.string :name, primary_key: true
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
