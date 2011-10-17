class AddCompanyToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :company_name, :string
    add_column :admins, :league_id, :integer
    add_column :admins, :league_url, :string
    add_column :admins, :last_login, :datetime
  end
end
