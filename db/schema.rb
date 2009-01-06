# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090106091141) do

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "regards_proposal_id"
    t.datetime "modified_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "proposal_count", :default => 1
    t.string   "logo"
  end

  create_table "proposals", :force => true do |t|
    t.text     "customer_requirement"
    t.text     "suggested_solution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.datetime "modified_at"
    t.integer  "company_id"
    t.integer  "display_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "admin"
  end

end
