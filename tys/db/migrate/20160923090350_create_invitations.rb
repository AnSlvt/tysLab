class CreateInvitation < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :leader_name, null: false
      t.string :target_name, null: false
      t.integer :application_id, null: false

      t.timestamps null: false
    end
  end
end
