object @activation_key

extends 'katello/api/v2/common/identifier'
extends 'katello/api/v2/common/org_reference'

attributes :environment_id
attributes :usage_count, :user_id, :usage_limit, :pools, :system_template_id

node :permissions do |activation_key|
  {
    :editable => true
  }
end

extends 'katello/api/v2/common/timestamps'
