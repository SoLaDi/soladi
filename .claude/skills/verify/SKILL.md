---
name: verify
description: Run the full SoLaDi check suite (Minitest then Playwright) to verify a change works. Use after making changes, before committing, or when asked to verify/test the app.
---

Verify changes by running both test layers in order. Report results plainly — if either layer fails, show the failing output and stop.

1. **Minitest** — run the Rails suite:
   ```
   rails test
   ```
   To narrow down a failure: `rails test path/to/file.rb -n test_name`. System tests (`rails test:system`) use Selenium Chrome and are slower — run them when the change touches views/JS.

2. **Playwright E2E** — run the browser suite (tests live in `tests/`, not `test/`):
   ```
   npx playwright test
   ```

Both layers must pass before a change is considered verified. SQLite is used for dev/test, so failures involving Postgres-specific SQL point to a real bug, not an environment quirk.
