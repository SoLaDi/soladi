# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

Rails 7.2 app, Ruby 3.3.6 (`.ruby-version`), Node v12.22.7 (`.nvmrc`), Yarn 1.x. Assets via Shakapacker 8 (webpack). Auth via Devise; model versioning via PaperTrail; Bootstrap 5 + ajax-datatables UI. The README's "Ruby 3.0.5" line is stale — use 3.3.6.

## Commands

- Install deps: `bundle install && yarn install`
- DB setup: `rails db:prepare` (create + migrate + seed), or `rake db:migrate && rake db:seed`
- Dev server: `rails server` → http://localhost:3000. For live JS rebuilds also run `bin/shakapacker-dev-server`.
- Seeded login: `test@test.de` / `supersicher`

## Testing — verify changes with BOTH layers

- Minitest (in `test/`): `rails test`; system tests `rails test:system` (Selenium Chrome). Single file: `rails test test/models/person_test.rb`. Single test: `rails test test/models/person_test.rb -n test_name`. Fixtures auto-load; suite runs parallel.
- Playwright E2E (in `tests/`, **not** `test/`): `npx playwright test`. Config in `playwright.config.ts`.

The `/verify` skill runs both in sequence.

## Database

SQLite in development and test; PostgreSQL in production (via `DB_URL`). Don't assume Postgres-only SQL in app code — it must work on SQLite locally.

## Workflow

Commit straight to `master` (no feature branches / PRs unless asked). No RuboCop/ESLint/Prettier configured — follow existing Rails conventions in the surrounding code.
