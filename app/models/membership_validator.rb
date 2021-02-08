class MembershipValidator < ActiveModel::Validator
  def validate(membership)
    if membership.endDate && membership.endDate < membership.startDate
      membership.errors.add :base, "Das Enddatum muss nach dem Startdatum liegen"
    end
  end
end