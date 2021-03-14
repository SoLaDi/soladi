class BidValidator < ActiveModel::Validator
  def validate(bid)
    other_bids = Bid.where.not(id: bid.id).where(membership_id: bid.membership_id)
    is_overlapping = other_bids.any? do |other_bid|
      bid.period.overlaps?(other_bid.period)
    end
    bid.errors.add :base, "Das Gebot überlappt mit bereits existierenden Geboten für die Mitgliedschaft" if is_overlapping
  end
end