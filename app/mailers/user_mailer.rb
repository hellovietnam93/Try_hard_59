class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("pass_reset.reset")
  end
end
