Rails.application.config.after_initialize do
  if Rails.application.config.active_storage.service == :cloudflare
    module ActiveStorage
      class Service::S3Service < Service
        def url(key, expires_in:, filename:, disposition:, content_type:)
          "https://static.superforum.io/#{key}"
        end

        def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:)
          instrument :url, key: key do |payload|
            generated_url = url(key, expires_in: expires_in, filename: ActiveStorage::Filename.new(""), disposition: :attachment, content_type: content_type)
            payload[:url] = generated_url
            generated_url
          end
        end

        private

        def object_for(key)
          bucket.object(key)
        end
      end
    end
  end
end