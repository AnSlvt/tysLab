class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :user_id, null: false
      t.integer :application_id, null: false

      t.timestamps null: false
    end
  end
end
