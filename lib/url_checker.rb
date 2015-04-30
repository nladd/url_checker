
require 'uri'
require 'json'

Dir[File.expand_path('../url_checker/**/*.rb',__FILE__)].each { |f| require f }

module UrlChecker

  class << self

    def self.check_urls(urls)
      UrlChecker::CheckerJob.queue(urls)
    end

    def config
      config = UrlChecker::Configuration
      yield(config) if block_given?
      config
    end

  end

  private
  class << self

    def checker
      @checker || UrlChecker::Checker.new
    end

  end
end
