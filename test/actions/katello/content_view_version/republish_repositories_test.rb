require 'katello_test_helper'

module Katello::Host
  class RepublishRepositoriesTest < ActiveSupport::TestCase
    include Dynflow::Testing
    include Support::Actions::Fixtures
    include FactoryBot::Syntax::Methods

    before :all do
      User.current = users(:admin)
      @version = katello_content_view_versions(:library_view_version_2)
    end

    describe 'Version Republish Repositories' do
      let(:action_class) { ::Actions::Katello::ContentViewVersion::RepublishRepositories }
      let(:action) { create_action action_class }

      it 'plans with default values' do
        action.stubs(:action_subject).with(@version.content_view)

        plan_action(action, @version)

        assert_action_planned_with(action, ::Actions::Katello::Repository::BulkMetadataGenerate) do |plan_input|
          actual_ids = plan_input.first.ids.sort
          expected_ids = @version.repositories
                                 .joins(:root)
                                 .where.not(root: { mirroring_policy: ::Katello::RootRepository::MIRRORING_POLICY_COMPLETE })
                                 .ids
                                 .sort

          assert_equal expected_ids, actual_ids
        end
      end
    end
  end
end
