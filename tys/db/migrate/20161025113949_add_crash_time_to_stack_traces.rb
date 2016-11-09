class AddCrashTimeToStackTraces < ActiveRecord::Migration
  def change
    add_column :stack_traces, :crash_time, :datetime, null: false
  end
end
