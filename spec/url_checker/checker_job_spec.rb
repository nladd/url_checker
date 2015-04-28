require 'spec_helper'

RSpec.describe CheckerJob do

  let(:url_json) { "{\"owner_id\":1,\"report_name\":\"Test Report\",\"awards\":[{\"id\":1,\"url\":\"http://www.fastweb.com/\"},{\"id\":2,\"url\":\"https://www.google.com/\"},{\"id\":3,\"url\":\"invalid url\"},{\"id\":4,\"url\":\"www.cnn.com\"}]}" }
  let(:checker) { Checker.new }


  describe "#perform" do

    it "returns the results of the url checker with associated metadata" do
      results = CheckerJob.perform(url_json.to_s)

      expect(results["success"].size).to eq(2)
      expect(results["failed"].size).to eq(2)
      expect(results["owner_id"]).to eq(1)
      expect(results["report_name"]).to eq("Test Report")
    end

  end
end

class UrlCheckerResultsProcessor

  def self.process_results(urls)
    JSON.parse(urls)
  end
end
