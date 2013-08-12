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


module Katello
  class Api::V2::ProductsController < Api::V1::ProductsController

    include Api::V2::Rendering

    before_filter :verify_presence_of_organization_or_environment, :except => [:index, :show, :repositories]
    before_filter :find_optional_organization, :except => [:show]

    resource_description do
      api_version "v2"
    end

    def_param_group :product do
      param :product, Hash, :required => true, :action_aware => true do
        param :gpg_key_name, :identifier, :desc => "identifier of the gpg key"
        param :description, String, :desc => "Product description"
      end
    end

    api :GET, "/products", "List of products"
    def index
      query_string = params[:name] ? "name:#{params[:name]}" : params[:search]
      filters      = []

      options = {
          :filter        => filters,
          :load_records? => false
      }
      options[:sort_by] = params[:sort_by] if params[:sort_by]
      options[:sort_order]= params[:sort_order] if params[:sort_order]

      #items = Glue::ElasticSearch::Items.new(Product)
      #products, total_count = items.retrieve(query_string, params[:offset], options)

      products = Product.all
      total_count = products.length
      subtotal = products.length

      respond_for_index :collection => {:records => products, :subtotal => total_count, :total => subtotal}
    end

    api :GET, "/products/:id", "Show a product"
    param :id, :number, :desc => "product numeric identifier"
    def show
      super
    end

    api :PUT, "/products/:id", "Update a product"
    param :id, :number, :desc => "product numeric identifier"
    param_group :product
    param :product, Hash do
      param :recursive, :bool, :desc => "set to true to recursive update gpg key"
    end
    def update
      super
    end

    api :DELETE, "/products/:id", "Destroy a product"
    param :id, :number, :desc => "product numeric identifier"
    def destroy
      super
    end

    api :GET, "/products/:id/repositories", "List product's repositories"
    param :organization_id, :identifier, :desc => "organization identifier"
    param :environment_id, :identifier, :desc => "environment identifier"
    param :id, :number, :desc => "product numeric identifier"
    param :include_disabled, :bool, :desc => "set to True if you want to list disabled repositories"
    param :name, :identifier, :desc => "repository identifier"
    def repositories
      repositories = @product.repositories
      total_count = repositories.length
      subtotal = repositories.length
      respond_for_index :collection => {:records => repositories, :subtotal => total_count, :total => subtotal}
    end

    api :POST, "/products/:id/sync_plan", "Assign sync plan to product"
    param :organization_id, :identifier, :desc => "organization identifier"
    param :id, :number, :desc => "product numeric identifier"
    param :plan_id, :number, :desc => "Plan numeric identifier"
    def set_sync_plan
      super
    end

    api :DELETE, "/products/:id/sync_plan", "Delete assignment sync plan and product"
    param :organization_id, :identifier, :desc => "organization identifier"
    param :id, :number, :desc => "product numeric identifier"
    param :plan_id, :number, :desc => "Plan numeric identifier"
    def remove_sync_plan
      super
    end

    def find_product
      @product = Product.find_by_cp_id(params[:id])
      raise HttpErrors::NotFound, _("Couldn't find product with id '%s'") % params[:id] if @product.nil?
    end

  end
end
