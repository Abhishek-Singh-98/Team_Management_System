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

ActiveRecord::Schema[7.0].define(version: 2024_11_11_181841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employee_teams", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_teams_on_employee_id"
    t.index ["team_id"], name: "index_employee_teams_on_team_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.integer "experience"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "employees_skills", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "skill_id"
    t.index ["employee_id"], name: "index_employees_skills_on_employee_id"
    t.index ["skill_id"], name: "index_employees_skills_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_name"
    t.text "description"
    t.integer "team_owner_id"
    t.integer "max_member"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_teams_on_manager_id"
  end

  add_foreign_key "teams", "employees", column: "manager_id"
end
