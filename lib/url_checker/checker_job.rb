class CheckerJob
  @queue = :url_checker_queue

  def self.perform(urls)
    begin
      parsed_urls = JSON.parse(urls)
      owner_id = parsed_urls["owner_id"]
      report_name = parsed_urls["report_name"]

      results = UrlChecker.checker.check_urls(parsed_urls)
      results.merge!({owner_id: owner_id, report_name: report_name})
      results = JSON.generate(results)
    rescue JSON::ParserError => e
      results = JSON.generate({status: "failed", message: "Invalid JSON. #{e.message}"})
    end

    UrlCheckerResultsProcessor.process_results(results)
  end

  def self.queue(urls)
    Resque.enqueue(self, urls)
  end
end
