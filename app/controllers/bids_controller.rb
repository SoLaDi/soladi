class BidsController < ApplicationController
  before_action :set_bid, only: [:show, :edit, :update, :destroy]

  def import
    begin
      import_status = Bid.import(params[:file])
      Rails.logger.info import_status.message
      if import_status.invalid_rows > 0
        redirect_to :bids, alert: "Import fehlerhaft! #{import_status.message}"
      else
        redirect_to :bids, notice: "Import abgeschlossen! #{import_status.message}"
      end
    rescue StandardError => e
      redirect_to :bids, notice: "Import fehlgeschlagen: #{e.message}"
    end
  end

  def export_csv
    respond_to do |format|
      format.csv { send_data Bid.all.to_csv }
    end
  end

  # GET /bids
  # GET /bids.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: BidDatatable.new(params, view_context: view_context) }
    end
  end

  # GET /bids/1
  # GET /bids/1.json
  def show; end

  # GET /bids/new
  def new
    @bid = Bid.new
  end

  # GET /bids/1/edit
  def edit
    Rails.cache.clear
  end

  # POST /bids
  # POST /bids.json
  def create
    @bid = Bid.new(bid_params)

    respond_to do |format|
      if @bid.save
        Rails.cache.clear
        format.html { redirect_to @bid, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bids/1
  # PATCH/PUT /bids/1.json
  def update
    respond_to do |format|
      if @bid.update(bid_params)
        Rails.cache.clear
        format.html { redirect_to @bid, notice: 'Bid was successfully updated.' }
        format.json { render :show, status: :ok, location: @bid }
      else
        format.html { render :edit }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.json
  def destroy
    @bid.destroy
    respond_to do |format|
      Rails.cache.clear
      format.html { redirect_to bids_url, notice: 'Bid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bid
    @bid = Bid.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bid_params
    params.require(:bid).permit(:start_date, :end_date, :amount, :shares, :contract_signed, :membership_id)
  end
end
