# frozen_string_literal: true

require 'capybara'
require 'capybara/cuprite'
require 'capybara-screenshot/rspec'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'site_prism/all_there'

# Capybara.current_driver = :selenium_chrome
Capybara.asset_host = 'http://localhost:3000'
Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], inspector: true)
end
