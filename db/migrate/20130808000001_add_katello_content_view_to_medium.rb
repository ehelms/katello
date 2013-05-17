class AddKatelloContentViewToMedium < ActiveRecord::Migration
  def change
    add_column :media, :content_view_id, :integer

    add_index :media, :content_view_id, :name => "index_medium_on_content_view_id"
  end
end
