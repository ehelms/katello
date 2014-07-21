#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Katello
  module Concerns
    module UsersControllerExtensions
      extend ActiveSupport::Concern
      include ForemanTasks::Triggers

      included do
        alias_method_chain :create, :dynflow
        alias_method_chain :destroy, :dynflow
      end

      def create_with_dynflow
        sync_task(::Actions::Katello::User::Create, @user)
        process_success
      end

      def destroy_with_dynflow
        @user = find_resource(:destroy_users)
        if @user == User.current
          notice _("You cannot delete this user while logged in as this user.")
          redirect_to :back and return
        else
          sync_task(::Actions::Katello::User::Destroy, @user)
          process_success
        end
      end

    end
  end
end
