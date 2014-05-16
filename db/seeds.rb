Location.find_or_create_by_name(:name => first_location_name)

if Katello.config.use_pulp
  Katello::Repository.ensure_sync_notification
end

ConfigTemplate.where(:name => "Katello Kickstart Default").first_or_create!(
    :template_kind_id    => TemplateKind.find_by_name('provision').id,
    :operatingsystem_ids => Operatingsystem.where("name not like ? and type = ?", "Red Hat Enterprise Linux", "Redhat").map(&:id),
    :template            => File.read("#{Katello::Engine.root}/app/views/foreman/unattended/kickstart-katello.erb"))

ConfigTemplate.where(:name => "Katello Kickstart Default for RHEL").first_or_create!(
    :template_kind_id    => TemplateKind.find_by_name('provision').id,
    :operatingsystem_ids => Redhat.where("name like ?", "Red Hat Enterprise Linux").map(&:id),
    :template            => File.read("#{Katello::Engine.root}/app/views/foreman/unattended/kickstart-katello_rhel.erb"))

ConfigTemplate.where(:name => "subscription_manager_registration").first_or_create!(
    :snippet  => true,
    :template => File.read("#{Katello::Engine.root}/app/views/foreman/unattended/snippets/_subscription_manager_registration.erb"))

Katello::Util::Search.backend_search_classes.each{|c| c.create_index}
