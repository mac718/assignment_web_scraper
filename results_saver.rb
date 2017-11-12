require_relative 'web_scraper'

class ResultsSaver

  def save_results(results)
    CSV.open('results.csv', 'a') do |csv|
      results.scrape.each do |job|
        csv << job.values
      end
    end
  end
end