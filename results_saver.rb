class ResultsSaver

  def save_results(results)
    CSV.open('results.csv', 'a') do |csv|
      results.each do |job|
        csv << job.values
      end
    end
  end
end