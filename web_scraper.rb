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
    titles = []
    companies = []
    locations = []
    @page = @scraper.submit(@search)
    @divs = @page.search('.complete-serp-result-div')

    @page.search('.complete-serp-result-div').each do |div|
      companies << div.at('a .compName').text.strip
    end

    @page.search('.complete-serp-result-div').each do |div|
      locations << div.at('span .jobLoc').text
    end

    @page.search('.complete-serp-result-div').each do |div|
      titles << div.at('h3 a').text.strip
    end
    
   
    companies
    
    locations
    
    titles
    
  end

  def display_results
    pp scrape
  end

end

scrape = WebScraper.new
scrape.display_results