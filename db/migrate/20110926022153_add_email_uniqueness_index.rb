class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :admins, :email, :unique => true
  end

  def self.down
    remove_index :admins, :email
  end
end
