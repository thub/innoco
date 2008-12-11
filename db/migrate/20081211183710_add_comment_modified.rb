class AddCommentModified < ActiveRecord::Migration
  def self.up
    add_column :comments,:modified_at,:timestamp    
  end

  def self.down
    remove_column :comments,:modified_at
  end
end
