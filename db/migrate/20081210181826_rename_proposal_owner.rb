class RenameProposalOwner < ActiveRecord::Migration
  def self.up
    rename_column :proposals,:owner,:owner_id
  end

  def self.down
    rename_column :proposals,:owner_id,:owner
  end
end
