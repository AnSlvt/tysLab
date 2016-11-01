class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues, id: false do |t|
      t.integer :github_number, primary_key: true
      t.integer :stack_trace_id, null: false
      t.string :github_repository, null: false

      t.timestamps null: false
    end
  end
end
