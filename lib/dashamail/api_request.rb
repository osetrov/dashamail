module Dashamail
  class APIRequest

    def initialize(builder: nil)
      @request_builder = builder
    end

    def post(params: nil, headers: nil, body: {})
      validate_api_key

      begin
        response = self.rest_client.post do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    def patch(params: nil, headers: nil, body: {})
      validate_api_key

      begin
        response = self.rest_client.patch do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    def put(params: nil, headers: nil, body: {})
      validate_api_key

      begin
        response = self.rest_client.put do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    def get(params: nil, headers: nil)
      validate_api_key

      begin
        response = self.rest_client.get do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    def delete(params: nil, headers: nil)
      validate_api_key

      begin
        response = self.rest_client.delete do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    protected

    # Convenience accessors

    def api_key
      @request_builder.api_key
    end

    def api_endpoint
      @request_builder.api_endpoint
    end

    def timeout
      @request_builder.timeout
    end

    def open_timeout
      @request_builder.open_timeout
    end

    def proxy
      @request_builder.proxy
    end

    def ssl_options
      @request_builder.ssl_options
    end

    def adapter
      @request_builder.faraday_adapter
    end

    def symbolize_keys
      @request_builder.symbolize_keys
    end

    # Helpers

    def handle_error(error)
      error_params = {}

      begin
        if error.is_a?(Faraday::ClientError) && error.response
          error_params[:status_code] = error.response[:status]
          error_params[:raw_body] = error.response[:body]

          parsed_response = MultiJson.load(error.response[:body], symbolize_keys: symbolize_keys)

          if parsed_response
            error_params[:body] = parsed_response

            title_key = symbolize_keys ? :title : "title"
            detail_key = symbolize_keys ? :detail : "detail"

            error_params[:title] = parsed_response[title_key] if parsed_response[title_key]
            error_params[:detail] = parsed_response[detail_key] if parsed_response[detail_key]
          end

        end
      rescue MultiJson::ParseError
      end

      error_to_raise = Error.new(error.message, error_params)

      raise error_to_raise
    end

    def configure_request(request: nil, params: nil, headers: nil, body: nil)
      if request
        request.params.merge!(params) if params
        request.params.merge!({api_key: Dashamail::Request.api_key, method: @request_builder.path})
        request.headers['Content-Type'] = 'application/json'
        request.headers['User-Agent'] = "Dashamail/#{Dashamail::VERSION} Ruby gem"
        request.headers.merge!(headers) if headers
        request.body = body if body
        request.options.timeout = self.timeout
        request.options.open_timeout = self.open_timeout
      end
    end

    def rest_client
      client = Faraday.new(self.api_url, proxy: self.proxy, ssl: self.ssl_options) do |faraday|
        faraday.response :raise_error
        faraday.adapter adapter
        if @request_builder.debug
          faraday.response :logger, @request_builder.logger, bodies: true
        end
      end
      client
    end

    def parse_response(response)
      parsed_response = nil

      if response.body && !response.body.empty?
        begin
          headers = response.headers
          body = MultiJson.load(response.body, symbolize_keys: symbolize_keys)
          err_code = body.dig(:response, :msg, :err_code).to_i
          if err_code > 0 && err_code != 4
            err_text = body.dig(:response, :msg, :text)
            error_params = { title: err_text, status_code: err_code }
            error = Error.new("???????????? #{err_code}: #{err_text}", error_params)
            raise error
          end
          parsed_response = Response.new(headers: headers, body: body)
        rescue MultiJson::ParseError
          error_params = { title: "UNPARSEABLE_RESPONSE", status_code: 500 }
          error = Error.new("Unparseable response: #{response.body}", error_params)
          raise error
        end
      end

      parsed_response
    end

    def validate_api_key
      unless self.api_key
        raise Dashamail::Error, "You must set an access_token prior to making a call"
      end
    end

    def api_url
      base_api_url# + @request_builder.path
    end

    def base_api_url
      "#{Dashamail.host}/"
    end
  end
end
