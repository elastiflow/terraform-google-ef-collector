# Iterate over modules
GO_TEST_EXCLUDE_MOD_REGEX?='something_that_does_not_exist_by_default'
GO_TEST_FIND_MOD_CMD:=find . -type f -name 'go.mod' -not -path '*/.terragrunt-cache/*' | grep -vE '${GO_TEST_EXCLUDE_MOD_REGEX}'
define GO_MOD_LOOP
	@${GO_TEST_FIND_MOD_CMD} | while read -r svc; do \
		dir=$$(dirname "$${svc}"); \
		echo 'Running "$(1)" in '$${dir}; \
		(cd $${dir} && $(1)) || exit 1; \
	done
endef

######################
# Terratest targets
######################
.PHONY: test-integration
test-integration:
	$(call GO_MOD_LOOP,go test -timeout 900s -p=1 ./ && echo)
