class Api::BidsController < Api::ApiController
  def create
    @bid = Bid.new(bid_params)
    if @bid.save
      render json: @bid, status: :accepted
    else
      render json: @bid.errors, status: :unprocessable_entity
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:start_date, :end_date, :amount, :shares, :membership_id)
  end
end
