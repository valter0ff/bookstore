# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'intership-bookstore.herokuapp.com',
  user_name: 'apikey',
  password: Rails.application.credentials.dig(:sendgrid, :api_key),
  authentication: 'plain',
  enable_starttls_auto: true
}
