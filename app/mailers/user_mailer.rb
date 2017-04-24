class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t "mailer.activation"
  end
end
