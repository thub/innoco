class ProposalAddDisplayId < ActiveRecord::Migration
  def self.up
    add_column :proposals, :display_id, :integer
  end

  def self.down
    remove_column :proposals, :display_id
  end
end
