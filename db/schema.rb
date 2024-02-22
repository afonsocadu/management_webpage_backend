# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_01_15_224444) do

  create_table "employees", force: :cascade do |t|
    t.string "user_name"
    t.text "technologies"
    t.integer "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_employees_on_project_id"
  end

  create_table "employees_technologies", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "technology_id"
    t.index ["employee_id"], name: "index_employees_technologies_on_employee_id"
    t.index ["technology_id"], name: "index_employees_technologies_on_technology_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects_technologies", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "technology_id"
    t.index ["project_id"], name: "index_projects_technologies_on_project_id"
    t.index ["technology_id"], name: "index_projects_technologies_on_technology_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "employees", "projects"
end
