class PeopleMailer < ApplicationMailer

  def payment_overdue_reminder_mail
    @person = params[:person]
    mail(to: @person.email, subject: 'SoLaWi Mitgliedsbeitrag überfällig!')
  end

  def bidding_round_invite_mail
    @person = params[:person]
    mail(to: @person.email, subject: 'SoLaWi Bieterrunde 2025 - bitte jetzt abstimmen!')
  end

  def agreement_mail
    @person = params[:person]
    @membership = @person.membership
    @bid = @membership.bid_for(Date.new(2025, 4, 1))
    attachments["vereinbarung.pdf"] = { :mime_type => 'application/pdf', :content => render_to_string("memberships/agreement", formats: [:pdf]) }
    mail(to: @person.email, subject: 'SoLaWi Mitgliedsvereinbarung 2025 - bitte unterschreiben!')
  end
end
