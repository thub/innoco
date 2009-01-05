class ExtendTextFields < ActiveRecord::Migration
  def self.up
    change_column :comments, :text, :text
    change_column :proposals, :customer_requirement, :text
    change_column :proposals, :suggested_solution, :text
  end

  def self.down
    change_column :comments, :text, :string, :limit => 256
    change_column :proposals, :customer_requirement, :string, :limit => 256
    change_column :proposals, :suggested_solution, :string, :limit => 256
    
  end
end
