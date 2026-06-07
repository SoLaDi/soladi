# Bids Index — Average Price Chart

## Overview

Add a line chart to the bottom of the bids index page (`/bids`) showing the weighted average bid price per share per month, spanning 6 months in the past to 6 months into the future (13 data points total).

## Data

**Metric:** `Bid.average_share_price(date)` — already exists on the model. Returns `total_monthly_revenue / total_shares` across all bids active in the given month, i.e. the weighted average price per share per month.

**Range:** 13 months — `6.months.ago.beginning_of_month` through `6.months.from_now.beginning_of_month`, stepped monthly.

**Labels:** Month abbreviation + year (e.g. "Jan 2026"), formatted with `I18n.l`.

## Architecture

**Pattern:** Identical to `home/index.html.erb` — data computed in the controller, embedded as JSON in the ERB template, rendered with Chart.js via an inline `<script>` block.

**Controller (`BidsController#index`):** On HTML requests, compute `@bid_price_chart` as a plain Ruby hash:

```ruby
@bid_price_chart = {
  labels: [...],   # 13 month label strings
  data:   [...]    # 13 Float values from Bid.average_share_price
}
```

**View (`bids/index.html.erb`):** Add a Bootstrap card below the existing Aktionen card containing a `<canvas id="avgBidPriceChart">` and an inline Chart.js script.

## Visual Design

- **Chart type:** Line
- **Past months** (up to and including current month): solid `#36a2eb` line and dots
- **Future months**: dashed `#90caf9` line and dots — visually signals these are from already-scheduled bids, not projections
- **Today marker:** vertical dashed orange line at the current month
- **Y-axis:** EUR currency formatting (`Intl.NumberFormat` with `de-DE` locale, same as home page)
- **Tooltip:** shows formatted EUR value on hover
- **Card title:** "Durchschnittlicher Gebotspreis pro Monat"
- **Turbolinks cleanup:** chart instance destroyed on `turbolinks:before-cache` (same pattern as home page)

## What's not in scope

- Caching (data is cheap: 13 scalar DB aggregations)
- Filtering by fiscal year or membership
- Any other chart types or additional datasets
