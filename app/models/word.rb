class Word < ApplicationRecord
  validates :word, presence: true

  belongs_to :scraper_job
end
