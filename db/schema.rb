# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 7) do

  create_table "galleries", :force => true do |t|
    t.string  "name",        :default => "NULL"
    t.text    "description", :default => "NULL"
    t.boolean "status",      :default => false
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "permalink"
  end

  add_index "galleries", ["permalink"], :name => "index_galleries_on_permalink", :unique => true
  add_index "galleries", ["name"], :name => "index_galleries_on_name", :unique => true
  add_index "galleries", ["status"], :name => "index_galleries_on_status"

  create_table "pictures", :force => true do |t|
    t.integer "gallery_id",   :default => 0
    t.string  "content_type", :default => "NULL"
    t.string  "filename",     :default => "NULL"
    t.integer "parent_id",    :default => 0
    t.integer "size",         :default => 0
    t.integer "width",        :default => 0
    t.integer "height",       :default => 0
    t.integer "position",     :default => 0
    t.string  "title",        :default => "NULL"
    t.text    "description",  :default => "NULL"
    t.boolean "status",       :default => false
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "permalink"
  end

  add_index "pictures", ["permalink"], :name => "index_pictures_on_permalink", :unique => true
  add_index "pictures", ["filename"], :name => "index_pictures_on_filename"
  add_index "pictures", ["gallery_id"], :name => "index_pictures_on_gallery_id"

  create_table "settings", :force => true do |t|
    t.text "settings", :default => "NULL"
  end

  create_table "thumbnails", :force => true do |t|
    t.string  "content_type", :default => "NULL"
    t.string  "thumbnail",    :default => "NULL"
    t.string  "filename",     :default => "NULL"
    t.integer "parent_id",    :default => 0
    t.integer "size",         :default => 0
    t.integer "width",        :default => 0
    t.integer "height",       :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                   :default => "NULL"
    t.string   "email",                                   :default => "NULL"
    t.string   "crypted_password",          :limit => 40, :default => "NULL"
    t.string   "salt",                      :limit => 40, :default => "NULL"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",                          :default => "NULL"
    t.datetime "remember_token_expires_at"
  end

end
