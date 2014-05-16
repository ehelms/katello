# create basic roles
superadmin_role = Katello::Role.make_super_admin_role

# update the Foreman 'admin' to be Katello super admin
::User.current = user_admin = ::User.admin
fail "Foreman admin does not exist" unless user_admin

# create a self role for user_admin, this is normally created during admin creation;
# however, for the initial migrate/seed, it needs to be done manually
user_admin.katello_roles.find_or_create_own_role(user_admin)
user_admin.katello_roles << superadmin_role unless user_admin.katello_roles.include?(superadmin_role)
user_admin.remote_id = user_admin.login
user_admin.save!
fail "Unable to update admin user: #{format_errors(user_admin)}" if user_admin.errors.size > 0
