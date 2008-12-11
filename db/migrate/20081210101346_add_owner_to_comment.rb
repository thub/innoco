class AddOwnerToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :owner, :integer
  end

  def self.down
    remove_column :comments, :owner
  end
end
