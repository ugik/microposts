class AddPasswordToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :encrypted_password, :string
  end
end
