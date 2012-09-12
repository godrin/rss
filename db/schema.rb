# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120912185943) do

  create_table "assigns", :force => true do |t|
    t.string   "type"
    t.integer  "parent_id"
    t.integer  "child_id"
    t.string   "author"
    t.integer  "value"
    t.boolean  "read"
    t.boolean  "done"
    t.integer  "subscribe_threshold"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "assigns", ["child_id"], :name => "index_assigns_on_child_id"
  add_index "assigns", ["parent_id"], :name => "index_assigns_on_parent_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entities", :force => true do |t|
    t.string   "url"
    t.string   "urlrss"
    t.string   "name"
    t.string   "description"
    t.string   "type"
    t.string   "state"
    t.datetime "publication"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "author"
  end

  add_index "entities", ["name"], :name => "index_entities_on_name"
  add_index "entities", ["type"], :name => "index_entities_on_type"
  add_index "entities", ["url"], :name => "index_entities_on_url"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
