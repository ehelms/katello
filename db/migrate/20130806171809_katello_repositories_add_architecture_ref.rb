class KatelloRepositoriesAddArchitectureRef < ActiveRecord::Migration
  def change
    add_column :katello_repositories, :architecture_id, :integer
  end
end
