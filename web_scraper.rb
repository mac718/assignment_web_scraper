require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'
require 'csv'

class WebScraper

  def initialize
    @scraper = Mechanize.new { |agent| 
          agent.user_agent_alias = "Linux Firefox"}
    @page = @scraper.get('https://www.dice.com/')
    @search = @page.form_with(:action => '/jobs')
    @search.q = "ruby rails"
    @search.l = "San Francisco, CA"
    @scraper.history_added = Proc.new { sleep 0.5 }
    @results = []
  end

  def search
    @divs.map do |div|
      {
      company: div.at('a .compName').text.strip,
      location: div.at('span .jobLoc').text,
      title: div.at('h3 a').attributes['title'].value,
      link: div.at('h3 a').attributes['href'].value,
      posting_date: div.at('span[@itemprop = datePosted]').text
      }
    end

  end

  def next_page
    @page = @scraper.submit(@search)

  end

  def scrape
    @page = @scraper.submit(@search)
    @divs = @page.search('.complete-serp-result-div')
    search
  end
  def display_results
    pp scrape
  end

end


scrape = WebScraper.new
scrape.display_results