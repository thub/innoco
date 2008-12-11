class AddRegardsProposal < ActiveRecord::Migration
  def self.up
    add_column :comments, :regards_proposal, :integer
  end

  def self.down
    drop_column :comments,:regards_proposal
  end
end
