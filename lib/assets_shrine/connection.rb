require "http"
require "connection_pool"

module AssetsShrine
  class Connection
    class InvalidRequest < StandardError; end
    class FailedRequest < StandardError; end

    TIMEOUT          = 60
    READ_TIMEOUT     = 60
    WRITE_TIMEOUT    = 60
    CONNECTION_POOL  = 5
    CONNECT_TIMEOUT  = 2

    attr_reader :internal_url, :api_token

    def initialize(internal_url:, api_token:)
      @internal_url = internal_url
      @api_token = api_token
    end

    def upload_file(file, filename, service_name, upload_id)
      raise InvalidRequest if file.nil?

      response = connection.with do |c|
        c.post(
          "#{internal_url}/assets",
          form: { upload: HTTP::FormData::File.new(file, filename: filename), service_name: service_name, upload_id: upload_id }
        )
      end

      raise FailedRequest.new(json_response(response)) unless response.status.success?
      json_response(response)['upload_id']
    end

    def destroy_file(token)
      raise InvalidRequest if token.nil?

      response = connection.with do |c|
        c.delete("#{internal_url}/assets/#{token}")
      end
      raise FailedRequest.new(json_response(response)) unless response.status.success?
      true
    end

    def update_file(token, file, service_name = nil)
      raise InvalidRequest if file.nil? || token.nil?

      response = connection.with do |c|
        c.put("#{internal_url}/assets/#{token}", form: { upload: HTTP::FormData::File.new(file), type: identify_type(file), service_name: service_name })
      end
      raise FailedRequest.new(json_response(response)) unless response.status.success?
      token
    end

    def get_url(token, service_name = nil, private_key = nil)
      raise InvalidRequest if token.nil?

      response = connection.with do |c|
        c.get("#{internal_url}/assets/#{token}?service_name=#{service_name}&private_key=#{private_key}")
      end

      json_response(response)['url']
    end

    private

    def json_response(response)
      JSON.parse(response.to_s)
    end

    def connection
      @connection ||= ConnectionPool.new(size: CONNECTION_POOL, timeout: TIMEOUT) do
        HTTP.headers('Authorization' => api_token)
            .accept(:json)
            .nodelay
            .timeout(connect: CONNECT_TIMEOUT, read: READ_TIMEOUT, write: WRITE_TIMEOUT)
      end
    end
  end
end
