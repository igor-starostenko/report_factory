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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180304025304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "project_id"
    t.string "reportable_type"
    t.bigint "reportable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tags", default: [], array: true
    t.index ["project_id"], name: "index_reports_on_project_id"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
  end

  create_table "rspec_examples", force: :cascade do |t|
    t.bigint "rspec_report_id"
    t.string "spec_id"
    t.text "description"
    t.text "full_description"
    t.string "status"
    t.string "file_path"
    t.integer "line_number"
    t.float "run_time"
    t.string "pending_message"
    t.index ["rspec_report_id"], name: "index_rspec_examples_on_rspec_report_id"
  end

  create_table "rspec_exceptions", force: :cascade do |t|
    t.bigint "rspec_example_id"
    t.string "classname"
    t.string "message"
    t.text "backtrace", default: "--- []\n"
    t.index ["rspec_example_id"], name: "index_rspec_exceptions_on_rspec_example_id"
  end

  create_table "rspec_reports", force: :cascade do |t|
    t.string "version"
    t.string "summary_line"
  end

  create_table "rspec_summaries", force: :cascade do |t|
    t.bigint "rspec_report_id"
    t.float "duration"
    t.integer "example_count"
    t.integer "failure_count"
    t.integer "pending_count"
    t.integer "errors_outside_of_examples_count"
    t.index ["rspec_report_id"], name: "index_rspec_summaries_on_rspec_report_id"
  end

  create_table "user_reports", force: :cascade do |t|
    t.integer "user_id"
    t.integer "report_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "email"
    t.string "password_digest"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
