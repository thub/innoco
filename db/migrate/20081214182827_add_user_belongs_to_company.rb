class AddUserBelongsToCompany < ActiveRecord::Migration
  def self.up
    add_column :users, :company_id, :integer
    execute "update users set company_id = 1"
  end

  def self.down
    remove_column :users, :company_id
  end
end
