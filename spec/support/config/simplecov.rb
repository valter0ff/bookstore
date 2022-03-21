# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter ['app/jobs', 'app/mailers']
  minimum_coverage 80
end
