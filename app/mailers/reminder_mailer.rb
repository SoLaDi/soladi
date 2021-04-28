class ReminderMailer < ApplicationMailer

  def payment_overdue_reminder_mail
    @person = params[:person]
    mail(to: 'marco_hoyer@gmx.de', subject: 'SoLaWi Mitgliedsbeitrag überfällig!')
  end
end