# frozen_string_literal: true

require 'i18n/debug' if ENV['DEBUG'] && Rails.env.development?
I18n.load_path = I18n.load_path.sort
