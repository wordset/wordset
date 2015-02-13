class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signed_up.subject
  #
  def signed_up(user)
    @greeting = "Hi"

    mail to: user.email, subject: "Welcome to Wordset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.approved.subject
  #
  def approved(user)
    @greeting = "Hi"

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.rejected.subject
  #
  def rejected(user)
    @greeting = "Hi"

    mail to: user.email
  end
end
