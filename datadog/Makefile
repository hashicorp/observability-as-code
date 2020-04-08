docker-dashboard:
	jq '.resource.datadog_dashboard.docker = \
	(.widget = .widgets | .template_variable = .template_variables | \
	.widget |= map((. | .definition.request = .definition.requests | del(.definition.requests) | ."\(.definition.type)_definition" = .definition ) | \
	del(."\(.definition.type)_definition".type, ."\(.definition.type)_definition".legend_size) // .) | \
	del(.widget[].definition, .widget[].id, .widgets, .template_variables, .id)) | \
	del(.title, .description, .layout_type, .is_read_only, .notify_list, .id, .widgets, .template_variables)' \
	dashboard/docker.json > dashboard-docker.tf.json