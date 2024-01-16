setup: install

install:
	bundle install
	yarn install
	bundle exec rails db:create db:migrate assets:precompile

test:
	bundle exec rake test

lint:
	bundle exec rubocop

init-env:
	cp env.example .env

.PHONY: test
