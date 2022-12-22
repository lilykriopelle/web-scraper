require 'httparty'

class ScraperJobCreator < ApplicationService
  attr_accessor :root_url, :depth, :parent_id, :scraper_job

  def initialize(root_url:, depth: 2, parent_id: nil)
    @root_url = root_url
    @depth = depth
    @parent_id = parent_id
  end

  def call
    create_scraper_job
  end

  private
  def create_scraper_job
    @scraper_job = ScraperJob.create(root_url: format_url(root_url), depth:, parent_id:)

    begin
      page = HTTParty.get(scraper_job.root_url)
      parse_page = Nokogiri::HTML(page)

      create_words_for(page_text(parse_page))

      unless depth == 0
        parse_page.css('a').each do |link|
          unless shouldnt_scrape?(link)
            ScraperJobCreator.call(parent_id: scraper_job.id, root_url: format_url(link.attr('href')),
                                  depth: depth - 1)
          end
        end
      end

      scraper_job
    rescue URI::InvalidURIError, NoMethodError
    end
  end

  def create_words_for(page_text)
    words = page_text.squish.gsub(/[^a-z0-9\-']/i, ' ').split(' ').map do |word|
      { word: word.gsub(/[^a-z0-9\-']/i, '').downcase }
    end

    scraper_job.words.insert_all(words)
  end

  def page_text(parse_page)
    parse_page.css('style').each(&:remove)
    parse_page.css('script').each(&:remove)
    Loofah.fragment(parse_page.to_html).to_text
  end

  def shouldnt_scrape?(child_link)
    child_link.attr('href').nil? || already_scraped?(child_link.attr('href')) || cross_origin?(child_link.attr('href')) || anchor_link?(child_link)
  end

  def already_scraped?(url)
    format_url(url) == root_url || ScraperJob.find(scraper_job.root.id).descendants.find do |sj|
      sj.root_url == format_url(url)
    end.present?
  end

  def cross_origin?(url)
    host = Addressable::URI.parse(url).host
    host.present? && host != Addressable::URI.parse(root_url).host
  end

  def anchor_link?(child_link)
    child_link.attr('href').first == '#'
  end

  def format_url(url)
    host = Addressable::URI.parse(url)&.host
    host.present? ? url : (Addressable::URI.parse(root_url) + url).to_s.sub(%r{(/)+$}, '')
  end
end
