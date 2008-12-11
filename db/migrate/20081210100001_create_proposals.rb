class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.string :customer_requirement
      t.string :suggested_solution

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
