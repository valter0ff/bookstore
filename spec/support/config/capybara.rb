# frozen_string_literal: true

require 'capybara'
require 'capybara-screenshot/rspec'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'site_prism/all_there'

# Capybara.current_driver = :selenium_chrome
Capybara.asset_host = 'http://localhost:3000'
