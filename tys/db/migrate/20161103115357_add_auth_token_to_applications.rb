class AddAuthTokenToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :authorization_token, :string, null: false, unique: true
  end
end
