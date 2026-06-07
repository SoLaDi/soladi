# Bids Average Price Chart Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a line chart to the bottom of the bids index page showing the weighted average bid price per share per month across 13 months (6 past + current + 6 future).

**Architecture:** Server-side data computation in `BidsController#index` (matching the home page pattern) assigns `@bid_price_chart` with labels and data arrays, which the view embeds as JSON and passes to Chart.js. Two overlapping datasets (past=solid blue, future=dashed lighter blue) share the current month point to create a visual split at today.

**Tech Stack:** Rails 7.2, Chart.js 4.4 (already installed), Bootstrap 5, jQuery (already on page via DataTables), Minitest

---

## Files

- Modify: `app/controllers/bids_controller.rb` — extend `#index` to compute `@bid_price_chart`
- Modify: `app/views/bids/index.html.erb` — add Bootstrap card with `<canvas>` and inline Chart.js script
- Modify: `test/controllers/bids_controller_test.rb` — add test for chart data assignment

---

## Task 1: Compute chart data in the controller

**Files:**
- Modify: `app/controllers/bids_controller.rb`
- Test: `test/controllers/bids_controller_test.rb`

- [ ] **Step 1: Write the failing test**

Add this test to `test/controllers/bids_controller_test.rb` inside the `BidsControllerTest` class, after the existing `"should get index"` test:

```ruby
test "index assigns 13-month bid price chart data" do
  get bids_url
  assert_response :success
  chart = assigns(:bid_price_chart)
  assert_not_nil chart
  assert_equal 13, chart[:labels].length
  assert_equal 13, chart[:data].length
  assert chart[:data].all? { |v| v.is_a?(Float) }
end
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
rails test test/controllers/bids_controller_test.rb -n "test_index_assigns_13-month_bid_price_chart_data"
```

Expected: FAIL — `chart` will be `nil` because `@bid_price_chart` is not yet assigned.

- [ ] **Step 3: Implement the chart data computation**

In `app/controllers/bids_controller.rb`, replace the `index` action:

```ruby
def index
  respond_to do |format|
    format.html do
      today = Date.today.beginning_of_month
      months = (-6..6).map { |n| today >> n }
      @bid_price_chart = {
        labels: months.map { |m| m.strftime("%b %Y") },
        data: months.map { |m| Bid.average_share_price(m).to_f }
      }
    end
    format.json { render json: BidDatatable.new(params, view_context: view_context) }
  end
end
```

`today >> n` advances the date by `n` months (`>> -6` = 6 months ago). `average_share_price` returns `total_monthly_revenue / total_shares` for all bids active in that month (already defined on the model).

- [ ] **Step 4: Run the test to verify it passes**

```bash
rails test test/controllers/bids_controller_test.rb -n "test_index_assigns_13-month_bid_price_chart_data"
```

Expected: PASS

- [ ] **Step 5: Run the full controller test suite to check for regressions**

```bash
rails test test/controllers/bids_controller_test.rb
```

Expected: all tests pass. The JSON format path is unchanged so no regressions expected.

- [ ] **Step 6: Commit**

```bash
git add app/controllers/bids_controller.rb test/controllers/bids_controller_test.rb
git commit -m "Compute average bid price chart data in BidsController#index"
```

---

## Task 2: Render the chart in the view

**Files:**
- Modify: `app/views/bids/index.html.erb`

- [ ] **Step 1: Add the chart card and Chart.js script**

Append the following to the end of `app/views/bids/index.html.erb` (after the closing `</div>` of the Aktionen card):

```erb
<br>
<br>

<div class="card">
  <h3 class="card-header">Durchschnittlicher Gebotspreis pro Monat</h3>
  <div class="card-body">
    <canvas id="avgBidPriceChart"></canvas>
  </div>
</div>

<script>
$(document).ready(function() {
  var avgBidPriceChart;

  document.addEventListener('turbolinks:before-cache', function() {
    if (avgBidPriceChart) { avgBidPriceChart.destroy(); avgBidPriceChart = null; }
  }, { once: true });

  if (document.getElementById('avgBidPriceChart')) {
    var currency_formatter = new Intl.NumberFormat('de-DE', {
      style: 'currency',
      currency: 'EUR',
    });

    var labels = <%= @bid_price_chart[:labels].to_json.html_safe %>;
    var allData = <%= @bid_price_chart[:data].to_json.html_safe %>;
    var todayIndex = 6;

    var todayLinePlugin = {
      id: 'todayLine',
      afterDraw: function(chart) {
        var ctx = chart.ctx;
        var xAxis = chart.scales.x;
        var yAxis = chart.scales.y;
        var x = xAxis.getPixelForValue(todayIndex);
        ctx.save();
        ctx.beginPath();
        ctx.moveTo(x, yAxis.top);
        ctx.lineTo(x, yAxis.bottom);
        ctx.lineWidth = 1.5;
        ctx.strokeStyle = '#f90';
        ctx.setLineDash([5, 4]);
        ctx.stroke();
        ctx.restore();
      }
    };

    var ctx = document.getElementById('avgBidPriceChart').getContext('2d');
    avgBidPriceChart = new Chart(ctx, {
      type: 'line',
      plugins: [todayLinePlugin],
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Vergangenheit',
            data: allData.map(function(v, i) { return i <= todayIndex ? v : null; }),
            borderColor: '#36a2eb',
            backgroundColor: '#36a2eb',
            borderWidth: 2,
            pointRadius: 4,
            fill: false,
          },
          {
            label: 'Zukunft',
            data: allData.map(function(v, i) { return i >= todayIndex ? v : null; }),
            borderColor: '#90caf9',
            backgroundColor: '#90caf9',
            borderDash: [6, 4],
            borderWidth: 2,
            pointRadius: 4,
            fill: false,
          }
        ]
      },
      options: {
        plugins: {
          tooltip: {
            mode: 'index',
            callbacks: {
              label: function(context) {
                if (context.parsed.y === null) return null;
                return context.dataset.label + ': ' + currency_formatter.format(context.parsed.y);
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: false,
            ticks: {
              callback: function(value) {
                return currency_formatter.format(value);
              }
            }
          }
        }
      }
    });
  }
});
</script>
```

The two datasets share the data point at `todayIndex = 6` (the current month), which visually joins the solid and dashed segments. The `turbolinks:before-cache` listener mirrors the cleanup pattern used on the home page.

- [ ] **Step 2: Start the Rails server and visit /bids**

```bash
rails server
```

Open http://localhost:3000/bids and log in with `test@test.de` / `supersicher`.

Verify:
- A card titled "Durchschnittlicher Gebotspreis pro Monat" appears at the bottom of the page
- The line chart renders with 13 data points
- The left half of the line is solid blue, the right half is dashed lighter blue
- Hovering a data point shows a EUR-formatted tooltip
- The Y-axis tick labels are in EUR format

- [ ] **Step 3: Run the full test suite**

```bash
rails test
```

Expected: all tests pass (the view change has no server-side test impact).

- [ ] **Step 4: Commit**

```bash
git add app/views/bids/index.html.erb
git commit -m "Add average bid price line chart to bids index page"
```
