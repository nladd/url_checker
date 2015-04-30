require 'json'
require 'open-uri'
require 'net/http'

module UrlChecker
class Checker

  def initialize; end


  def check_urls(urls)
    @results = {success: [], failed: []}
    traverse_urls(urls)

    @results
  end

  private

  def check_url(url)
    begin
      if uri = URI.parse(url)

        return [false, "No protocol specified for URL"] if URI::Generic == uri.class

        if Configuration.proxy_configured?
          net = Net::HTTP.new(uri.host, uri.port, Configuration.proxy_host, Configuration.proxy_port, Configuration.proxy_user, Configuration.proxy_password)
        else
          net = Net::HTTP.new(uri.host, uri.port)
        end
        net.use_ssl = uri.scheme == "https" ? true : false
        begin
          res = net.request_head(uri.path.empty? ? "/" : uri.path)

          res_code = res.code.to_i
          if res_code >= 200 && res_code < 400
            [true, "HTTP response code: #{res_code}", res_code]
          elsif res_code >= 400 && res_code < 600
            [false, "HTTP response code: #{res_code}", res_code]
          end
        rescue => e
          [false, e.message]
        end

      end
    rescue URI::InvalidURIError => e
      [false, e.message]
    end


  end

  def traverse_urls(urls)

    urls.each do |k, v|
      if k.to_s.downcase == "url"
        validity = check_url(v)
        if validity[0]
          @results[:success] << urls.merge({validity: {status: "success", http_resp_code: validity[2], message: validity[1]}})
        else
          @results[:failed] << urls.merge({validity: {status: "failed", http_resp_code: validity[2], message: validity[1]}})
        end
      elsif k.is_a? Hash
        traverse_urls(k)
      elsif v.is_a? Array
        v.each do |elm|
          traverse_urls(elm)
        end
      end
    end
  end

end
end
