class AddColumnToStackTraces < ActiveRecord::Migration
  def change
    add_column :stack_traces, :fixed, :boolean
  end
end
