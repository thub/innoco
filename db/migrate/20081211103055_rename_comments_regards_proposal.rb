class RenameCommentsRegardsProposal < ActiveRecord::Migration
  def self.up
    rename_column :comments,:regards_proposal,:regards_proposal_id
  end

  def self.down
    rename_column :comments,:regards_proposal_id,:regards_proposal
  end
end
