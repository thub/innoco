class AddProposalModified < ActiveRecord::Migration
  def self.up
    add_column :proposals,:modified_at,:timestamp
  end

  def self.down
    remove_column :proposals,:modified_at
  end
end
