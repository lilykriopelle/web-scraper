Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'scraper_jobs#show'

  post 'scrape', to: 'scraper_jobs#create'
  get 'stats', to: 'scraper_jobs#show'
end
