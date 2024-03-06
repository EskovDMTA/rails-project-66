class UserMailer < ApplicationMailer
  def check_failure_email(repository)
    @user = repository.user
    mail(to: @user.email, subject: 'Отчет о проверке кода')
  end
end
