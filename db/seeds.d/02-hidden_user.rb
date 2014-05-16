unless hidden_user = ::User.hidden.first
  ::User.current = ::User.admin
  login = "hidden-#{Password.generate_random_string(6)}".downcase
  hidden_user = ::User.new(:auth_source_id => AuthSourceInternal.first.id,
                           :login => login,
                           :password => Password.generate_random_string(25),
                           :mail => "#{Password.generate_random_string(10)}@localhost",
                           :remote_id => login,
                           :hidden => true,
                           :katello_roles => [])
  hidden_user.save!
  fail "Unable to create hidden user: #{format_errors hidden_user}" if hidden_user.nil? || hidden_user.errors.size > 0
end
