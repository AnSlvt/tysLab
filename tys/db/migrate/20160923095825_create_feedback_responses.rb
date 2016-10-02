class CreateFeedbackResponses < ActiveRecord::Migration
  def change
    create_table :feedback_responses do |t|
      t.integer :response_id, null: false
      t.integer :target_id, null: false
      t.string :response_author, null: false

      t.timestamps null: false
    end
  end
end
