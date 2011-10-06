class AddCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :league_id, :integer
    add_column :users, :last_login, :datetime
  end
end
