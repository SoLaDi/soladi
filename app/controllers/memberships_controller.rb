class MembershipsController < ApplicationController
  require 'active_support/all'

  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  def send_payment_overdue_reminder_mails
    recipients = Membership.overdue.map { |m| m.people }.flatten
    Rails.logger.info("Going to send reminder mails to the following members: #{recipients}")

    recipients.each do |recipient|
      ReminderMailer.with(person: recipient).payment_overdue_reminder_mail.deliver_now
    end

    redirect_to :memberships, notice: "E-Mail Versand abgeschlossen an #{recipients.length} Empfänger!"
  rescue Exception => e
    redirect_to :memberships, notice: "E-Mail Versand fehlgeschlagen: #{e.message}"
  end

  def import
    begin
      import_status = Membership.import(params[:file])
      Rails.logger.info import_status.message
      if import_status.invalid_rows > 0
        redirect_to :memberships, alert: "Import fehlerhaft! #{import_status.message}"
      else
        redirect_to :memberships, notice: "Import abgeschlossen! #{import_status.message}"
      end
    rescue Exception => e
      redirect_to :memberships, notice: "Import fehlgeschlagen: #{e.message}"
    end
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
