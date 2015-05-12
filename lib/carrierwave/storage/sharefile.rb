require 'pathname'

module CarrierWave
  module Storage
    class Sharefile < Abstract
      def store!(file)
        f = CarrierWave::Storage::Sharefile::File.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      def retrieve!(identifier)
        f = CarrierWave::Storage::Sharefile::File.new(uploader, self, uploader.store_path(identifier))
        f.retrieve(identifier)
        f
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def filename
          Pathname.new(path).basename.to_s
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

        def initialize(uploader, base, path)
          @uploader, @base, @path = uploader, base, path
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
        # Write file to service
        #
        # === Returns
        #
        # [Boolean] true on success or raises error
        #
        def store(file)
          sharefile_file = file.to_file
          @content_type ||= file.content_type
          @file = client.store_document(.......)
          @uploader.sharefile_attributes.merge!(@file.parsed_response)
        end

        ##
        # Retrieve file from service
        #
        # === Returns
        #
        # [File]
        #
        def retrieve(identifier)
          @file = client.get_document(.....)
          @file ||= @file.parsed_response
        end

        private

        def model
          @uploader.model
        end

        def client
          CarrierWave::Sharefile::Client.new(@uploader.sharefile_api_key)
        end

        def file
          tmp = client.get_document(.....)
          @file ||= IO.binread(tmp.parsed_response)
          @file
        end

      end
    end
  end
end
