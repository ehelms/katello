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
require 'test/models/authorization/repository_authorization_test'


class RepositoryCreateTest < MiniTest::Rails::ActiveSupport::TestCase
  include RepositoryTestBase

  def setup
    @acme_corporation   = create(:organization, :acme_corporation)
    @fedora_hosted      = create(:provider, :fedora_hosted, :organization => @acme_corporation)
    @fedora             = create(:product, :fedora, :provider => @fedora_hosted, :environments => [@acme_corporation.library])
    environment_product = EnvironmentProduct.where(:environment_id => @acme_corporation.library.id, :product_id => @fedora.id).first
    @repo               = build(:repository, :fedora_17_x86_64, :environment_product => environment_product)
  end

  def teardown
    @repo.destroy
  end

  def test_create
    assert @repo.save
  end

end


class RepositoryInstanceTest < MiniTest::Rails::ActiveSupport::TestCase
  include RepositoryTestBase

  def generate_library_repository
    @acme_corporation     = create(:organization, :acme_corporation)
    @library              = @acme_corporation.library
    @fedora_hosted        = create(:provider, :fedora_hosted, :organization => @acme_corporation)
    @fedora               = create(:product, :fedora, :provider => @fedora_hosted, :environments => [@acme_corporation.library])
    library_fedora        = EnvironmentProduct.where(:environment_id => @acme_corporation.library.id, :product_id => @fedora.id).first
    @fedora_17_x86_64     = create(:repository, :fedora_17_x86_64, :environment_product => library_fedora)
  end

  def generate_dev_repository
    generate_library_repository
    @dev                  = create(:k_t_environment, :dev, :organization => @acme_corporation, :priors => [@acme_corporation.library])
    @fedora.environments << @dev
    @fedora.save
    dev_fedora            = EnvironmentProduct.where(:environment_id => @dev.id, :product_id => @fedora.id).first
    @fedora_17_x86_64_dev = create(:repository, :fedora_17_x86_64_dev, :environment_product => dev_fedora, :library_instance => @fedora_17_x86_64)
  end

  def test_product
    generate_library_repository
    assert_equal @fedora.id, @fedora_17_x86_64.product.id
  end

  def test_environment
    generate_library_repository
    assert_equal @library.id, @fedora_17_x86_64.environment.id
  end

  def test_organization
    generate_library_repository
    assert_equal @acme_corporation.id, @fedora_17_x86_64.organization.id
  end

  def test_redhat?
    generate_library_repository
    assert !@fedora_17_x86_64.redhat?
  end

  def test_custom?
    generate_library_repository
    assert @fedora_17_x86_64.custom?
  end

  def test_in_environment
    generate_library_repository
    assert_includes Repository.in_environment(@library), @fedora_17_x86_64
  end

  def test_in_product
    generate_library_repository
    assert_includes Repository.in_product(@fedora), @fedora_17_x86_64
  end

  def test_other_repos_with_same_content
    generate_dev_repository
    assert_includes @fedora_17_x86_64.other_repos_with_same_content, @fedora_17_x86_64_dev
  end

  def test_other_repos_with_same_product_and_content
    generate_dev_repository
    assert_includes @fedora_17_x86_64.other_repos_with_same_product_and_content, @fedora_17_x86_64_dev
  end

  def test_environment_id
    generate_library_repository
    assert @fedora_17_x86_64.environment_id == @library.id
  end

  def test_clones
    generate_dev_repository
    assert_includes @fedora_17_x86_64.clones, @fedora_17_x86_64_dev
  end

  def test_is_cloned_in?
    generate_dev_repository
    assert @fedora_17_x86_64.is_cloned_in?(@dev)
  end

  def test_promoted?
    generate_dev_repository
    assert @fedora_17_x86_64.promoted?
  end

  def test_get_clone
    generate_dev_repository
    assert_equal @fedora_17_x86_64.get_clone(@dev), @fedora_17_x86_64_dev
  end


  def test_as_json
    generate_library_repository
    assert @fedora_17_x86_64.as_json.has_key? "gpg_key_name"
  end

  def test_environmental_instances
    generate_dev_repository
    assert_includes @fedora_17_x86_64.environmental_instances, @fedora_17_x86_64
    assert_includes @fedora_17_x86_64.environmental_instances, @fedora_17_x86_64_dev
  end

=begin
  def test_has_filters?
    generate_library_repository
    assert !@fedora_17_x86_64.has_filters?
  end

  def test_applicable_filters
    generate_dev_repository
    assert @fedora_17_x86_64_dev.applicable_filters.include?(@fedora_filter)
  end

  def test_gpg_key_name
    generate_library_repository
    @fedora_17_x86_64.gpg_key_name = @unassigned_gpg_key.name
    assert @fedora_17_x86_64.gpg_key == @unassigned_gpg_key
  end

  def test_yum_gpg_key_url
    generate_library_repository
    assert !@fedora_17_x86_64.yum_gpg_key_url.nil?
  end
=end
end
