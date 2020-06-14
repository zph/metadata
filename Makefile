mix.lock: mix.exs
	mix deps.get
	touch mix.lock

.PHONY: start
run: mix.lock
	iex --erl "-kernel shell_history enabled" -S mix

.PHONY: format
format: mix.lock
	mix format
