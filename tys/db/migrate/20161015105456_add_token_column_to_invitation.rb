class AddTokenColumnToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :invite_token, :string, null: false
  end
end
