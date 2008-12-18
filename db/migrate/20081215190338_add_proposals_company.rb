class AddProposalsCompany < ActiveRecord::Migration
  def self.up
    add_column :proposals, :company_id, :integer
    execute "update proposals set company_id = 1"    
  end

  def self.down
    remove_column :proposals, :company_id
  end
end
