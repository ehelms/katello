module Katello
  module Concerns
    module RedhatExtensions
      extend ActiveSupport::Concern

      included do
        alias_method_chain :medium_uri, :content_uri
      end

      def medium_uri_with_content_uri(host, url = nil)
        if url.nil?
          full_path = ContentViewVersion.where(:content_view_id => host.content_view_id).first.repositories.first.full_path
          URI.parse(full_path)
        else
          medium_uri_without_content_uri(host, url)
        end
      end

    end
  end
end
