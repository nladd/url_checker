
require 'uri'
require 'json'

Dir[File.expand_path('../url_checker/**/*.rb',__FILE__)].each { |f| require f }

class UrlChecker


  def self.check_urls(urls)
    CheckerJob.queue(urls)
  end

  private
  class << self

    def checker
      @checker || Checker.new
    end

  end
end
