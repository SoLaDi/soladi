#!/usr/bin/env bash
set -e

docker-compose -f scripts/docker-compose-local-dev.yml up -d

export RAILS_ENV=production
export SECRET_KEY_BASE=some-secret
export DB_URL=postgresql://postgres:postgres@localhost:5432/soladi
export RAILS_SERVE_STATIC_FILES=true

bundle install --without development test
yarn install
rails assets:precompile

rails db:migrate RAILS_ENV=production
#rails db:seed RAILS_ENV=production

rails server -e production -b 0.0.0.0
