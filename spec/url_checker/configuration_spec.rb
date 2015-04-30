require 'spec_helper'

RSpec.describe UrlChecker::Configuration do

  describe "configuration" do
    it "should allow a proxy to be configured" do
      UrlChecker.config do |config|
        config.proxy_host = "proxy_host"
        config.proxy_port = 3000
        config.proxy_user = "user"
        config.proxy_password = "password"
      end

      expect(UrlChecker::Configuration.proxy_host).to eq("proxy_host")
      expect(UrlChecker::Configuration.proxy_port).to eq(3000)
      expect(UrlChecker::Configuration.proxy_user).to eq("user")
      expect(UrlChecker::Configuration.proxy_password).to eq("password")
    end
  end
end
