# frozen_string_literal: true

require 'capybara'
require 'capybara/apparition'
require 'capybara/cuprite'
require 'capybara-screenshot/rspec'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'site_prism/all_there'

# Capybara.current_driver = :selenium_chrome
Capybara.asset_host = 'http://localhost:3000'
# Capybara.javascript_driver = :chrome_headless
Capybara.javascript_driver = :cuprite
# Capybara.javascript_driver = :apparition

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], inspector: true)
end

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, headless: false)
end
# Capybara.register_driver :chrome_headless do |app|
# #   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
# #     chromeOptions: {
# #       args: %w[ no-sandbox headless disable-gpu ]
# #     }
# #   )
#   options = Selenium::WebDriver::Chrome::Options.new
#   options.add_argument('--no-sandbox')
# #   options.add_argument('--disable-gpu')
#   options.add_argument('--disable-popup-blocking')
#
#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end
