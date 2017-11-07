require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'

class WebScraper

  def initialize
    @scraper = Mechanize.new
    @page = @scraper.get('https://www.dice.com/')
    @search = @page.form_with(:action => '/jobs')
    @search.q = "ruby rails"
    @search.l = "Ann Arbor, MI"
    @scraper.history_added = Proc.new { sleep 0.5 }
  end

  def scrape
    @page = @scraper.submit(@search)
  end

  def display_results
    pp scrape
  end

end

scrape = WebScraper.new
scrape.display_results