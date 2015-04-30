module UrlChecker
  module Configuration
    extend self

    attr_reader :proxy_host, :proxy_port, :proxy_user, :proxy_password
    @proxy_configured = false

    def proxy_host=(host)
      @proxy_host = host
      @proxy_configured = true
    end

    def proxy_port=(port)
      @proxy_port = port
      @proxy_configured = true
    end

    def proxy_user=(user)
      @proxy_user = user
      @proxy_configured = true
    end

    def proxy_password=(password)
      @proxy_password = password
      @proxy_configured = true
    end

    def proxy_configured?
      @proxy_configured
    end
  end
end
