class CreateKatelloContentViewOperatingsystems < ActiveRecord::Migration
  def change
    create_table :katello_content_view_operatingsystems do |t|
       t.references :operatingsystem, :null =>false
       t.references :content_view, :null =>false
    end
    add_index(:katello_content_view_operatingsystems, [:operatingsystem_id, :content_view_id],:name=>'content_view_operatingsystems_index', :unique=>true)
  end
end
