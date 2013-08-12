object @provider

extends 'katello/api/v2/common/identifier'
extends 'katello/api/v2/common/org_reference'

attributes :provider_type
attributes :repository_url, :discovered_repos, :discovery_url

extends 'katello/api/v2/common/syncable'
extends 'katello/api/v2/common/timestamps'
