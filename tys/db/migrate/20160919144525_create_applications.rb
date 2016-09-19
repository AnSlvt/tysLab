class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :application_name, null: false
      t.string :author, null: false

      t.timestamps null: false
    end
  end
end
