class AddHostExtensions < ActiveRecord::Migration

  def change
    add_column :hosts, :content_view_id, :integer

    add_index :hosts, :content_view_id, :name => "index_hosts_on_content_view_id"
  end

end
