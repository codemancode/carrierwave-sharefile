require 'faraday'

module CarrierWave
  module Sharefile
    class Client
      require 'faraday'
      require 'faraday_middleware'
      require 'json'
      require 'uri'
      require 'open-uri'
      require 'tempfile'

      def initialize(client_id, client_secret, username, password, subdomain)
        @client_id = client_id
        @client_secret = client_secret
        @username = username
        @password = password
        @subdomain = subdomain
        instance_variables.each do |variable|
          raise ArgumentError, "#{variable} should not be nil or blank" if instance_variable_get(variable.to_sym).to_s == ""
        end
        access_token
      end

      def access_token
        params = {
          :grant_type => :password,
          :client_id => @client_id,
          :client_secret => @client_secret,
          :username => @username,
          :password => @password
        }
        puts params.inspect
        response = connection("sharefile").post 'oauth/token', params
        @access_token = response.body['access_token']
        @refresh_token = response.body['refresh_token']
        puts response.body
      end


      def get_document(identifier)
        response = get_item_by_id(identifier)
      end

      def store_document(store_path, file)
        puts "store_path #{store_path}"
        folder = get_item_by_path('/Client Portal')
        upload_config = upload_file_to_folder(folder)
        puts upload_config.inspect
        res = upload_media(upload_config.body['ChunkUri'], file)
      end

      private

      def upload_media(url, tmpfile)
        newline = "\r\n"
        filename = File.basename(tmpfile.path)
        boundary = "ClientTouchReceive----------#{Time.now.usec}"
           
        uri = URI.parse(url)
         
        post_body = []
        post_body << "--#{boundary}#{newline}"
        post_body << "Content-Disposition: form-data; name=\"File1\"; filename=\"#{filename}\"#{newline}"
        post_body << "Content-Type: application/octet-stream#{newline}"
        post_body << "#{newline}"
        post_body << File.read(tmpfile.path)
        post_body << "#{newline}--#{boundary}--#{newline}"
         
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = post_body.join
        request["Content-Type"] = "multipart/form-data, boundary=#{boundary}"
        request['Content-Length'] = request.body().length
       
        http = Net::HTTP.new uri.host, uri.port
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         
        response = http.request request
        return {:response => response, :id => filename}
      end

      def upload_file_to_folder(folder)
        headers = {"Authorization" => "Bearer #{@access_token}"}
        body = {:method => 'standard', :fileName => 'testitout', :title => 'test upload', :details => 'test description'}
        response = connection.post "sf/v3/Items(#{folder.body['Id']})/Upload", body, headers
      end

      def get_item_by_path(path = '/')
        headers = {"Authorization" => "Bearer #{@access_token}"}
        response = connection.get "sf/v3/Items/ByPath?path=#{path}", {}, headers
      end

      def get_item_by_id(identifier)
        headers = {"Authorization" => "Bearer #{@access_token}"}
        response = connection.get "sf/v3/Items/(#{identifier})?includeDeleted=false", {}, headers
      end

      def connection(endpoint = "sf-api")
        Faraday.new(:url => "https://#{@subdomain}.#{endpoint}.com/") do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.use FaradayMiddleware::ParseJson
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end

    end
  end
end
