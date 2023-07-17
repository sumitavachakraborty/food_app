# frozen_string_literal: true

# User Mailer
class UserMailer < ApplicationMailer
  def confirmation_email(user, login_link)
    @user = user
    @login_link = login_link
    mail(to: @user.email, subject: 'confirm your email')
  end
end
