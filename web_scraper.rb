require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'
require 'csv'
require_relative 'results_saver'

class WebScraper

  def initialize
    @scraper = Mechanize.new { |agent| 
          agent.user_agent_alias = "Linux Firefox"}
    @page_number = 1
    @page = @scraper.get("https://www.dice.com/jobs?q=ruby+OR+ralis&l=San+Francisco%2C+CA&startPage=#{@page_number}")
    @number_of_pages = @page.search('#posiCountId').text.to_i
    @divs = @page.search('.complete-serp-result-div')
    @scraper.history_added = Proc.new { sleep 0.5 }
    @csv = ResultsSaver.new
  end

  def organize_data
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

  def scrape
    until @divs.empty?
      binding.pry
      @csv.save_results(organize_data)
      @page_number += 1
      @page = @scraper.get("https://www.dice.com/jobs?q=ruby+OR+ralis&l=San+Francisco%2C+CA&startPage=#{@page_number}")
      @divs = @page.search('.complete-serp-result-div')
    end 
  end
end


WebScraper.new.scrape