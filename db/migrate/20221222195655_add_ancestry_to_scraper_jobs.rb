class AddAncestryToScraperJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :scraper_jobs, :ancestry, :string
    add_index :scraper_jobs, :ancestry
  end
end
