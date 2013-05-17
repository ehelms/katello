module Katello
  module Concerns
    module HostsAndHostgroupsHelperExtension
      extend ActiveSupport::Concern

      included do
        def os_media
          return [] if @operatingsystem.blank?
          if params[:content_view_id]
            @operatingsystem.media.with_content_view(params[:content_view_id])
          else
            @operatingsystem.media.without_content_views
          end
        end
      end

    end
  end
end
