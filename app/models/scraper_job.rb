class ScraperJob < ApplicationRecord
  validates :root_url, :depth, presence: true

  has_ancestry
  has_many :words, dependent: :destroy

  before_save { self.root_url = root_url.sub(%r{(/)+$}, '') }

  def is_root?
    parent.nil?
  end
end
