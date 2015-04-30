require 'spec_helper'

RSpec.describe UrlChecker::Checker do

  let(:url_json) { {awards: [ {id: 1, url: "http://www.fastweb.com/"}, {id: 2, url: "https://www.google.com/"}, {id: 3, url: "invalid url"}, {id: 4, url: "www.cnn.com"} ] } }
  let(:checker) { UrlChecker::Checker.new }


  describe "#check_urls" do

    it "checks if the given urls are valid" do
      results = checker.check_urls(url_json)

      expect(results[:success].size).to eq(2)
      expect(results[:failed].size).to eq(2)
    end

  end
end
