import 'core-js/stable'
import 'regenerator-runtime/runtime'
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("rateyo")
require("packs/raty")

import $ from 'jquery';

window.$ = $;
window.jQuery = $;

import 'bootstrap-sass/assets/javascripts/bootstrap';

import 'packs/raty';
import 'rateyo';
