class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :domain

      t.timestamps
    end
   execute "insert into companies (name,domain) values ('Demo',null)"
   execute "insert into companies (name,domain) values ('The gmail company','gmail.com')"
   execute "insert into companies (name,domain) values ('Eidsiva Energi','eidsivaenergi.no')"

  end

  def self.down
    drop_table :companies
  end
end
