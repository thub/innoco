class CompanyAddProposalCounter < ActiveRecord::Migration
  def self.up
    add_column :companies, :proposal_count, :integer, :default=>1
  end

  def self.down
    remove_column :companies, :proposal_count
  end
end
