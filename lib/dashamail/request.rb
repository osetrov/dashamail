module Dashamail
  class Request
    attr_accessor :api_key, :api_endpoint, :timeout, :open_timeout, :proxy, :ssl_options, :faraday_adapter, :symbolize_keys, :debug, :logger, :test

    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 60

    def initialize(api_key: nil, api_endpoint: nil, timeout: nil, open_timeout: nil, proxy: nil, ssl_options: nil, faraday_adapter: nil, symbolize_keys: false, debug: false, logger: nil, test: false)
      @path_parts = []
      @api_key = api_key || self.class.api_key
      @api_key = @api_key.strip if @api_key
      @api_endpoint = api_endpoint || self.class.api_endpoint
      @timeout = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @open_timeout = open_timeout || self.class.open_timeout || DEFAULT_OPEN_TIMEOUT
      @proxy = proxy || self.class.proxy || ENV['DASHAMAIL_PROXY']
      @ssl_options = ssl_options || self.class.ssl_options || { version: "TLSv1_2" }
      @faraday_adapter = faraday_adapter || self.class.faraday_adapter || Faraday.default_adapter
      @symbolize_keys = symbolize_keys || self.class.symbolize_keys || false
      @debug = debug || self.class.debug || false
      @test = test || self.class.test || false
      @logger = logger || self.class.logger || ::Logger.new(STDOUT)
    end

    def method_missing(method, *args)
      @path_parts << method.to_s
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end

    def send(*args)
      if args.length == 0
        method_missing(:send, args)
      else
        __send__(*args)
      end
    end

    def path
      @path_parts.join('.')
    end

    def create!(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def update!(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).patch(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def upsert!(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).put(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def retrieve!(params: nil, headers: nil)
      APIRequest.new(builder: self).get(params: params, headers: headers)
    ensure
      reset
    end

    def delete!(params: nil, headers: nil)
      APIRequest.new(builder: self).delete(params: params, headers: headers)
    ensure
      reset
    end

    protected

    def reset
      @path_parts = []
    end

    class << self
      attr_accessor :api_key, :timeout, :open_timeout, :api_endpoint, :proxy, :ssl_options, :faraday_adapter, :symbolize_keys, :debug, :logger, :test

      def method_missing(sym, *args, &block)
        new(api_key: self.api_key, api_endpoint: self.api_endpoint, timeout: self.timeout, open_timeout: self.open_timeout, faraday_adapter: self.faraday_adapter, symbolize_keys: self.symbolize_keys, debug: self.debug, proxy: self.proxy, ssl_options: self.ssl_options, logger: self.logger, test: self.test).send(sym, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end
  end
end
