#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.


require 'minitest_helper'

class NavigationTest < MiniTest::Rails::ActiveSupport::TestCase
  fixtures :organizations, :users

  def setup
    @acme_corporation = Organization.find(organizations(:acme_corporation).id)
    @admin            = User.find(users(:admin))
    User.current      = @admin
    Katello.config[:url_prefix] = '/katello'
  end

  def test_new
    navigation = Experimental::Navigation::Navigation.new

    refute_nil navigation
  end

  def test_generate_main_menu
    navigation = Experimental::Navigation::Navigation.new
    menu = navigation.generate_main_menu(@acme_corporation)

    assert_kind_of Array, menu
  end

end
