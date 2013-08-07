module Katello
  module Concerns
    module MediumExtensions
      extend ActiveSupport::Concern

      def self.create_medium(repositories, organization)

        repositories.each do |repository|
          repository.distributions.each do |distribution|
            create({
              :name => distribution.id,
              :path => repository.full_path,
              :os_family => 'Redhat',
              :organization_ids => [organization.id]
            })
          end
        end

      end

      private

      def self.create(args)
        params = {
          :name => args.fetch(:name),
          :path => args.fetch(:path),
          :os_family => args.fetch(:os_family),
          :organization_ids => args.fetch(:organization_ids)
        }

        media = Medium.new(params)
        media.save!
      end

    end
  end
end
