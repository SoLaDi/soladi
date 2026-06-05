// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import $ from 'jquery';
import DataTable from 'datatables.net-bs4';

window.$ = $;
window.jQuery = $;
$.fn.dataTable = DataTable;
$.fn.DataTable = DataTable;

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import { Chart, registerables } from 'chart.js';
Chart.register(...registerables);
window.Chart = Chart;

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Adds a per-column filter row to a server-side DataTable.
// `dt` is the DataTables API instance. `config.selects` maps a column index
// to an array of values (strings) or { value, label } objects to render as a
// dropdown; all other searchable columns get a debounced text input.
window.addColumnFilters = function (dt, config) {
    config = config || {};
    const selects = config.selects || {};
    const settings = dt.settings()[0];
    const $thead = $(dt.table().header());
    const $filterRow = $('<tr class="column-filters"></tr>');

    dt.columns().every(function (index) {
        const column = this;
        const $cell = $('<th></th>');

        if (settings.aoColumns[index].bSearchable) {
            const current = column.search();

            if (selects[index]) {
                const $select = $('<select class="form-select form-select-sm"></select>');
                $select.append('<option value="">Alle</option>');
                selects[index].forEach(function (opt) {
                    const value = typeof opt === 'string' ? opt : opt.value;
                    const label = typeof opt === 'string' ? opt : opt.label;
                    $('<option></option>')
                        .attr('value', value)
                        .prop('selected', current === value)
                        .text(label)
                        .appendTo($select);
                });
                $select.on('change', function () {
                    column.search(this.value).draw();
                });
                $cell.append($select);
            } else {
                let timer;
                const $input = $('<input type="text" class="form-control form-control-sm" placeholder="Filter…">');
                $input.val(current);
                $input.on('click', function (e) { e.stopPropagation(); });
                $input.on('keyup change', function () {
                    const value = this.value;
                    clearTimeout(timer);
                    timer = setTimeout(function () {
                        if (column.search() !== value) {
                            column.search(value).draw();
                        }
                    }, 400);
                });
                $cell.append($input);
            }
        }

        $filterRow.append($cell);
    });

    $thead.append($filterRow);
};

import * as bootstrap from 'bootstrap'

document.addEventListener("turbolinks:load", () => {
    // Bootstrap 5 uses data-bs-toggle instead of data-toggle
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))

    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
    const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))
})

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
