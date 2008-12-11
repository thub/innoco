class AddOwnerToProposal < ActiveRecord::Migration
  def self.up
      add_column :proposals, :owner, :integer
   end

  def self.down
      remove_column :proposals, :owner
  end
end
