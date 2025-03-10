class PeopleMailer < ApplicationMailer

  def payment_overdue_reminder_mail
    @person = params[:person]
    mail(to: @person.email, subject: 'SoLaWi Mitgliedsbeitrag überfällig!')
  end

  def bidding_round_invite_mail
    @person = params[:person]
    mail(to: @person.email, subject: 'SoLaWi Bieterrunde 2025 - bitte jetzt abstimmen!')
  end
end
