class AddSaltToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :salt, :string
  end
end
