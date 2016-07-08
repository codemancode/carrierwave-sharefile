require 'pathname'

module CarrierWave
  module Storage
    class Sharefile < Abstract
      def store!(file)
        f = CarrierWave::Storage::Sharefile::File.new(uploader, config, uploader.store_path, client)
        f.store(file)
        f
      end

      def retrieve!(identifier)
        f = CarrierWave::Storage::Sharefile::File.new(uploader, config, uploader.store_path(identifier), client)
        f.retrieve(identifier)
        f
      end

      def client
        CarrierWave::Sharefile::Client.new(config[:sharefile_client_id],
                                           config[:sharefile_client_secret], 
                                           config[:sharefile_username], 
                                           config[:sharefile_password],
                                           config[:sharefile_subdomain])
      end

      private

      def config
        @config ||= {}

        @config[:sharefile_client_id] ||= uploader.sharefile_client_id
        @config[:sharefile_client_secret] ||= uploader.sharefile_client_secret
        @config[:sharefile_username] ||= uploader.sharefile_username
        @config[:sharefile_password] ||= uploader.sharefile_password
        @config[:sharefile_subdomain] ||= uploader.sharefile_subdomain
        @config[:sharefile_root] ||= uploader.sharefile_root

        @config
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def initialize(uploader, config, path, client)
          @uploader, @config, @path, @client = uploader, config, path, client
        end

        def filename
          Pathname.new(path).basename.to_s
        end

        ##
        # Lookup URL for the path
        #
        # === Returns
        #
        # [String] URL of the download link
        #
        def url
          @client.get_download_link(@path)
        end

        ##
        # Lookup value for file content-type header
        #
        # === Returns
        #
        # [String] value of content-type
        #
        def content_type
          @content_type || file.content_type
        end

        ##
        # Set non-default content-type header (default is file.content_type)
        #
        # === Returns
        #
        # [String] returns new content type value
        #
        def content_type=(new_content_type)
          @content_type = new_content_type
        end

        ##
        # Read content of file from service
        #
        # === Returns
        #
        # [String] contents of file
        def read
          file
        end

        ##
        # Return size of file body
        #
        # === Returns
        #
        # [Integer] size of file body
        #
        def size
          file.content_length
        end

        def sharefile_attributes
          attributes
        end

        ##
        # Removes a file from the service
        #
        # === Returns
        #
        # [Boolean] true on success or raises error
        #
        def delete(identifier)
          @client.delete_document(identifier)
        end

        ##
        # Write file to service
        #
        # === Returns
        #
        # [Boolean] true on success or raises error
        #
        def store(file)
          sharefile_file = file.to_file
          @content_type ||= file.content_type
          root_folder = @config[:sharefile_root]
          @file = @client.store_document(root_folder, @path, sharefile_file)
        end

        ##
        # Retrieve file from service
        #
        # === Returns
        #
        # [File]
        #
        def retrieve(identifier)
          @file = @client.get_document(identifier)
          @file ||= @file.parsed_response
        end
      end
    end
  end
end
