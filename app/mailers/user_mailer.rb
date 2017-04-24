class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.activation")
  end

  def password_reset
    @greeting = t "password_reset.hello"
    mail to: "to@example.org"
  end
end
