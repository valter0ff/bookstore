# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_filter ['spec', 'app/jobs', 'app/mailers', 'app/models']
  minimum_coverage 95
end
