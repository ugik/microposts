class AddAdministratorToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :administrator, :boolean, :default => false
  end

  def self.down
    remove_column :admins, :administrator
  end
end

end
