# create the default org = "admin" if none exist

org_name = ENV['initial_organization'] || 'ACME Corporation'
org_label = 'ACME_Corporation'

first_org = Organization.create!(:name => org_name, :label => org_label)

fail "Unable to create first org: #{format_errors first_org}" if first_org && first_org.errors.size > 0
