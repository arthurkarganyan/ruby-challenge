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

ActiveRecord::Schema.define(version: 2021_06_03_170747) do

  create_table "film_reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "film_id", null: false
    t.integer "stars"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["film_id"], name: "index_film_reviews_on_film_id"
    t.index ["user_id"], name: "index_film_reviews_on_user_id"
  end

  create_table "films", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.string "rated"
    t.date "released"
    t.integer "runtime_min"
    t.string "genre"
    t.string "director"
    t.string "writer"
    t.string "actors"
    t.text "plot"
    t.string "language"
    t.string "country"
    t.string "awards"
    t.text "poster_url"
    t.json "ratings"
    t.integer "metascore"
    t.float "imdb_rating"
    t.integer "imdb_votes"
    t.string "imdb_id"
    t.string "film_type"
    t.date "released_on_dvd"
    t.string "box_office"
    t.string "production"
    t.string "website"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "show_times", force: :cascade do |t|
    t.integer "price"
    t.integer "film_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["film_id"], name: "index_show_times_on_film_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "role", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "film_reviews", "films"
  add_foreign_key "film_reviews", "users"
  add_foreign_key "show_times", "films"
end
