# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_message(user)
    @url = 'https://intership-bookstore.herokuapp.com/login'
    mail(to: user.email, subject: I18n.t('user_mailer.welcome_message.subject'))
  end
end
