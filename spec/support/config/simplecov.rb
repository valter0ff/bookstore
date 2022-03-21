# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter ['spec', 'app/jobs', 'app/mailers', 'app/models']
  minimum_coverage 80
end
