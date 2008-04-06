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

ActiveRecord::Schema.define(:version => 8) do

  create_table "galleries", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.boolean "status"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "permalink"
  end

  add_index "galleries", ["permalink"], :name => "index_galleries_on_permalink", :unique => true
  add_index "galleries", ["name"], :name => "index_galleries_on_name", :unique => true
  add_index "galleries", ["status"], :name => "index_galleries_on_status"

  create_table "imports", :force => true do |t|
    t.string   "path"
    t.integer  "gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["gallery_id"], :name => "index_imports_on_gallery_id"

  create_table "pictures", :force => true do |t|
    t.integer "gallery_id"
    t.string  "content_type"
    t.string  "filename"
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "position"
    t.string  "title"
    t.text    "description"
    t.boolean "status"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "permalink"
  end

  add_index "pictures", ["permalink"], :name => "index_pictures_on_permalink", :unique => true
  add_index "pictures", ["filename"], :name => "index_pictures_on_filename"
  add_index "pictures", ["gallery_id"], :name => "index_pictures_on_gallery_id"

  create_table "settings", :force => true do |t|
    t.text "settings"
  end

  create_table "thumbnails", :force => true do |t|
    t.string  "content_type"
    t.string  "thumbnail"
    t.string  "filename"
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
