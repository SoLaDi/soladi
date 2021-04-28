class ReminderMailer < ApplicationMailer

  def payment_overdue_reminder_mail
    @person = params[:person]
    mail(to: @person.email, subject: 'SoLaWi Mitgliedsbeitrag überfällig!')
  end
end