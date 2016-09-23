class CreateFeedback < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :text, null: false
      t.string :feedback_type, null: false
      t.integer :application_id, null: false
      t.string :email
      t.string :user_name

      t.timestamps null: false
    end
  end
end
