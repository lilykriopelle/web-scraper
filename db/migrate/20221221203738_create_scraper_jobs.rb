class CreateScraperJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :scraper_jobs do |t|
      t.string :root_url, null: false
      t.integer :depth, null: false, default: 2

      t.timestamps
    end
  end
end
