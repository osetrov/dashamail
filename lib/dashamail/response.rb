module Dashamail
  class Response
    attr_accessor :body, :headers
    
    def initialize(body: {}, headers: {})
      @body = body
      @headers = headers
    end

    def data
      body.try(:dig, :response, :data)
    end
  end
end
