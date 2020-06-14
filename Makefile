mix.lock: mix.exs
	mix deps.get
	touch mix.lock

.PHONY: start
run: mix.lock
	iex --erl "-kernel shell_history enabled" -S mix

.PHONY: format
format: mix.lock
	mix format

.PHONY: version
version:
	test -n $(VERSION) && \
	sed -i.bak 's/version: ".*"/version: "$(VERSION)"/' mix.exs && \
		git add mix.exs && \
		git commit -m "Version v$(VERSION)" && \
		git tag -a "v$(VERSION)" -m "v$(VERSION)" && \
		rm -f mix.exs.bak
