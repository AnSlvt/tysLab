class DropResponseFeedbacks < ActiveRecord::Migration
  def change
    drop_table :feedback_responses
    add_column :feedbacks, :parent_id, :integer
  end
end
