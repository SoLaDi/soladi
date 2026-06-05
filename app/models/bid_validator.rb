# frozen_string_literal: true

class BidValidator < ActiveModel::Validator
  def validate(bid)
    return unless bid.membership_id && bid.start_date && bid.end_date

    other_bids = Bid.where(membership_id: bid.membership_id)
    other_bids = other_bids.where.not(id: bid.id) if bid.persisted?

    is_overlapping = other_bids.any? do |other_bid|
      bid.period.overlap?(other_bid.period)
    end
    if is_overlapping
      bid.errors.add :base,
                     "Das Gebot überlappt mit bereits existierenden Geboten für die Mitgliedschaft"
    end

    is_ending_before_it_starts = bid.start_date > bid.end_date
    bid.errors.add :base, "Das Startdatum muss vor dem Enddatum liegen" if is_ending_before_it_starts
  end
end
