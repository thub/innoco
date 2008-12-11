class RenameCommentOwner < ActiveRecord::Migration
  def self.up
    rename_column :comments, :owner, :owner_id
  end

  def self.down
    rename_column :comments, :owner_id, :owner
  end
end
