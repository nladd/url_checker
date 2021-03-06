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

    it "should use a proxy if configured" do
      UrlChecker.config do |config|
        config.proxy_host = "proxy_host"
        config.proxy_port = 3000
        config.proxy_user = "user"
        config.proxy_password = "password"
      end

      uri = URI.parse("http://www.fastweb.com")
      expect(Net::HTTP).to receive(:new).with(uri.host, uri.port, UrlChecker::Configuration.proxy_host, UrlChecker::Configuration.proxy_port, UrlChecker::Configuration.proxy_user, UrlChecker::Configuration.proxy_password)

      results = checker.check_urls({awards: [ {id: 1, url: "http://www.fastweb.com/"} ]})

    end

  end
end
