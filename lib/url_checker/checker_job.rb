class CheckerJob
  @queue = :url_checker_queue

  def self.perform
    begin
      parsed_urls = JSON.parse(urls)

      results = UrlChecker.checker.check_urls(parsed_urls)
    rescue JSON::ParserError => e
      results = JSON.generate({status: "failed", message: "Invalid JSON. #{e.message}"})
    end

    UrlCheckerResultsProcessor.process_results(results)
  end

  def self.queue(urls)
    Resque.enqueue(self, urls)
  end
end
