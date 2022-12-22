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

ActiveRecord::Schema[7.0].define(version: 20_221_222_205_939) do
  create_table 'scraper_jobs', force: :cascade do |t|
    t.string 'root_url', null: false
    t.integer 'depth', default: 2, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'ancestry'
    t.index ['ancestry'], name: 'index_scraper_jobs_on_ancestry'
  end

  create_table 'words', force: :cascade do |t|
    t.integer 'scraper_job_id', null: false
    t.string 'word'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['scraper_job_id'], name: 'index_words_on_scraper_job_id'
    t.index ['word'], name: 'index_words_on_word'
  end

  add_foreign_key 'words', 'scraper_jobs'
end
