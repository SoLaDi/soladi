class MembershipsController < ApplicationController
  require 'active_support/all'

  before_action :set_membership, only: [:show, :edit, :update, :destroy, :send_payment_overdue_reminder_mail, :send_bidding_invite_mail]

  def send_payment_overdue_reminder_mail
    Rails.logger.info "Going to send the payment overdue reminder mail for membership #{@membership.id}"
    @membership.send_payment_overdue_reminder_mail

    redirect_to :memberships, notice: 'E-Mail Versand abgeschlossen!'
  rescue StandardError => e
    redirect_to :memberships, notice: "E-Mail Versand fehlgeschlagen: #{e.message}"
  end

  def send_bidding_invite_mail
    Rails.logger.info "Going to send the bidding invite mail to membership #{@membership.id}"
    @membership.send_bidding_invite_mail
    redirect_to :memberships, notice: 'E-Mail Versand abgeschlossen!'
  rescue StandardError => e
    redirect_to :memberships, notice: "E-Mail Versand fehlgeschlagen: #{e.message}"
  end

  def send_bidding_invite_mail_to_all_memberships
    Rails.logger.info 'Going to send the bidding invite mail'
    fails = 0

    Membership.all.each do |membership|
      membership.send_bidding_invite_mail
    rescue StandardError => e
      fails += 1
      Rails.logger.error "Failed to send bidding invite mail for #{membership.id}: #{e}"
    end

    if fails.positive?
      redirect_to :memberships, notice: "E-Mail Versand fehlgeschlagen für #{fails} Mitgliedschaften"
    else
      redirect_to :memberships, notice: 'E-Mail Versand abgeschlossen!'
    end
  end

  def import

    import_status = Membership.import(params[:file])
    Rails.logger.info import_status.message
    if import_status.invalid_rows.positive?
      redirect_to :memberships, alert: "Import fehlerhaft! #{import_status.message}"
    else
      redirect_to :memberships, notice: "Import abgeschlossen! #{import_status.message}"
    end
  rescue StandardError => e
    redirect_to :memberships, notice: "Import fehlgeschlagen: #{e.message}"

  end

  def overdue
    @memberships = Membership.overdue
  end

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
    @overdue_memberships = Membership.overdue
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @membership.bids.build()
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url, notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:terminated, :distribution_point_id, bids_attributes: [:shares, :amount, :start_date, :end_date])
  end
end
