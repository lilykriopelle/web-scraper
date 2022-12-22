class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.references :scraper_job, index: true, foreign_key: true, null: false
      t.string :word

      t.timestamps
    end
  end
end
