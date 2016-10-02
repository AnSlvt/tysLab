class CreateStackTraces < ActiveRecord::Migration
  def change
    create_table :stack_traces do |t|
      t.integer :application_id, null: false
      t.text :stack_trace_text, null: false
      t.text :stack_trace_message, null: false
      t.string :application_version

      t.timestamps null: false
    end
  end
end
