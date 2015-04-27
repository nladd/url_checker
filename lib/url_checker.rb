
require 'uri'
require 'json'

Dir[File.expand_path('../url_checker/**/*.rb',__FILE__)].each { |f| require f }

class UrlChecker


  def self.check_urls(urls)
    begin
      parsed_urls = JSON.parse(urls)

      checker.check_urls(parsed_urls)
    rescue JSON::ParserError => e
      JSON.generate({status: "failed", message: "Invalid JSON. #{e.message}"})
    end

  end

  private
  class << self

    def checker
      @checker || Checker.new
    end

  end
end
