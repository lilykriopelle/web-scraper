# README

This web scraper uses a recursive strategy to build a tree of scraped pages, each of which maintains records of the words found on it.

## Setup

Download the repository, run:
* `bundle install`
* `bundle exec rails db:setup`
* `rails s`

## `/scrape`

To scrape a page, make a POST request to  `/scrape` with the following in the request body:
* `root_url` (required) – the URL with which you want your scrape to start.
* `depth` (optional, defaults to 2) - the desired depth of your scrape. A depth of zero means that only the provided URL will be scraped, whereas a depth of two means the system will scrape the starting page, scrape all pages it links to, and scrape all pages those pages link to.

Once your scrape is complete, the API will return a scrape job object. You can use this object's `id` to retrieve the scrape stats for that job by passing it to the `/stats` endpoint.

## `/stats`

Making a GET request to `/stats` without specifying an ID will result in retrieve the stats for the most recent scrape

To retrieve the stats for a particular scrape, make a GET request to `/stats` and append `id=XXX` to the query string.

To view the scrape's word counts disaggregated by page, append `disaggregated=true` to the query string.

## Ideas for future improvements

Since scraping is time-consuming, I would in the future like to perform the bulk of the scraping in a background job. In an asynchronous paradigm, I imagine the endpoint would work something like: on receiving a POST request to `/scrape`, the API would create a scrape job with a `pending` status and return its `id` to the requester before enqueuing a job to perform the actual scraping.

When the scraping is actually done, the scrape job's status would be updated to `complete`.

This would allow the requester poll our API for their stats, and have that endpoint report that the job is incomplete as long as the scrape job's status remains in the `pending` state.
