class AddTypeToStackTraces < ActiveRecord::Migration
  def change
    add_column :stack_traces, :error_type, :string
  end
end
