class PeopleMailerPreview < ActionMailer::Preview
  def bidding_round_invite_mail
    PeopleMailer.with(person: Person.first).bidding_round_invite_mail
  end
end
