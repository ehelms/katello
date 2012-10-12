#
# Copyright 2012 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'test/models/repository_base'


class RepositoryAuthorizationTest < MiniTest::Rails::ActiveSupport::TestCase
  include RepositoryTestBase

  def setup
    @acme_corporation   = create(:organization, :acme_corporation)
    @library              = @acme_corporation.library
    @fedora_hosted      = create(:provider, :fedora_hosted, :organization => @acme_corporation)
    @fedora             = create(:product, :fedora, :provider => @fedora_hosted, :environments => [@acme_corporation.library])
    environment_product = EnvironmentProduct.where(:environment_id => @acme_corporation.library.id, :product_id => @fedora.id).first
    @fedora_17_86_64    = create(:repository, :fedora_17_x86_64, :environment_product => environment_product)
    User.current        = create(:admin)
  end

  def test_readable
    assert Repository.readable(@library)
  end

  def test_libraries_content_readable
    assert Repository.libraries_content_readable(@acme_corporation)
  end

  def test_content_readable
    assert Repository.content_readable(@acme_corporation)
  end

  def test_readable_for_product
    assert Repository.readable_for_product(@library, @fedora)
  end

  def test_editable_in_library
    assert Repository.editable_in_library(@acme_corporation)
  end

  def test_readable_in_org
    assert Repository.readable_in_org(@acme_corporation)
  end

  def test_any_readable_in_org?
    assert Repository.any_readable_in_org?(@acme_corporation)
  end

end
