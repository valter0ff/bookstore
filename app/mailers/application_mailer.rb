# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'valerii.pohrebniak@rubygarage.org'
  layout 'mailer'
end
