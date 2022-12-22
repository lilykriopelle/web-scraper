class ScraperJobsController < ApplicationController
  before_action :set_scraper_job, only: :show
  before_action :check_scrape_parameters, only: :create

  def create
    @scraper_job = ScraperJobCreator.call(root_url: scraper_job_params[:root_url],
                                         depth: scraper_job_params[:depth])
    render json: @scraper_job
  end

  def show
    if params[:disaggregated]
      data = ScraperJob.where(id: @scraper_job.descendants.pluck(:id) << params[:id]).joins(:words).group(:root_url,
                                                                                                        :word).count
      render json: disaggregate(data)
    else
      render json: Word.where(scraper_job_id: @scraper_job.descendants.pluck(:id) << params[:id]).group(:word).count
    end
  end

  private
  def check_scrape_parameters
    if scraper_job_params[:root_url].nil?
      render json: { error: 'You must provide a root url' }, status: 422
    end
  end

  def scraper_job_params
    params.require(:scraper_job).permit(:root_url, :depth)
  end

  def set_scraper_job
    if params[:id].nil?
      @scraper_job = ScraperJob.order(created_at: :asc).last&.root
    else
      @scraper_job = ScraperJob.find_by_id(params[:id])
    end

    if @scraper_job.nil?
      render json: { error: 'Record not found' }, status: 404
    end
  end

  def disaggregate(data)
    disaggregated = {}
    data.each do |key, value|
      if disaggregated[key.first].nil?
        disaggregated[key.first] = {}
        disaggregated[key.first][key.second] = value
      else
        disaggregated[key.first][key.second] = value
      end
    end
    disaggregated
  end
end
