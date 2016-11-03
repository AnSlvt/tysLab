class AddDeviceToStackTrace < ActiveRecord::Migration
  def change
    add_column :stack_traces, :device, :string
  end
end
