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

ActiveRecord::Schema[8.0].define(version: 2026_01_09_124602) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "allergies", force: :cascade do |t|
    t.bigint "skincare_resume_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skincare_resume_id"], name: "index_allergies_on_skincare_resume_id"
  end

  create_table "medications", force: :cascade do |t|
    t.bigint "skincare_resume_id", null: false
    t.date "started_on"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skincare_resume_id"], name: "index_medications_on_skincare_resume_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "skincare_resume_id", null: false
    t.date "started_on"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skincare_resume_id"], name: "index_products_on_skincare_resume_id"
  end

  create_table "skincare_resumes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_skincare_resumes_on_user_id"
    t.index ["uuid"], name: "index_skincare_resumes_on_uuid", unique: true
  end

  create_table "treatments", force: :cascade do |t|
    t.bigint "skincare_resume_id", null: false
    t.date "treated_on"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skincare_resume_id"], name: "index_treatments_on_skincare_resume_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "allergies", "skincare_resumes", on_delete: :cascade
  add_foreign_key "medications", "skincare_resumes", on_delete: :cascade
  add_foreign_key "products", "skincare_resumes", on_delete: :cascade
  add_foreign_key "skincare_resumes", "users", on_delete: :cascade
  add_foreign_key "treatments", "skincare_resumes", on_delete: :cascade
end
