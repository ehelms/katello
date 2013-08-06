Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_content_view_tab",
                     :insert_after => 'ul.nav > li a#params-tab',
                     :partial => 'katello/content_view_definitions/views/form_tab')

Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_content_view_tab_pane",
                     :insert_after => 'div.tab-pane#params',
                     :partial => 'katello/content_view_definitions/views/host_tab_pane')