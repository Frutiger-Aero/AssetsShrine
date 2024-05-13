require "down/http"

module AssetsShrine
  class Storage
    attr_reader :internal_url, :api_token

    def initialize(internal_url:, api_token:)
      @internal_url = internal_url
      @api_token = api_token
    end

    def upload(io, id, shrine_metadata: {}, **options)
      connection.upload_file(io.to_io, shrine_metadata["filename"], 'monolith', generated_id(id))
    end

    def url(id, **_options)
      return if id.nil?

      connection.get_url(generated_id(id))
    end

    def open(id)
      Down::Http.open(url(id))
    end

    def exists?(id)
      URI(url(id)).present?
    end

    def delete(id)
      connection.destroy_file(generated_id(id))
    end

    private

    def connection
      @connection ||= Connection.new(internal_url: internal_url, api_token: api_token)
    end

    def generated_id(id)
      id.delete('/').delete('.')
    end
  end
end
