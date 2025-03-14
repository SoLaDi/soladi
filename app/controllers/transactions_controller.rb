class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(params, view_context: view_context) }
    end
  end

  def list
    Transaction.where(membership: params[:membership_id]).find_each
  end

  def import
    begin
      import_status = Transaction.import(params[:file])
      Rails.logger.info import_status.message
      if import_status.invalid_rows > 0
        redirect_to :transactions, alert: "Import fehlerhaft! #{import_status.message}"
      else
        redirect_to :transactions, notice: "Import abgeschlossen! #{import_status.message}"
      end
    rescue Exception => e
      Rails.logger.info e.inspect
      Rails.logger.info e.backtrace
      redirect_to :transactions, notice: "Import fehlgeschlagen: #{e.message}"
    end
  end

  def export_csv
    respond_to do |format|
      format.html
      format.csv { send_data Transaction.all.to_csv }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new(membership_id: params[:membership_id], description: params[:status_message], entry_date: Date.today, sender: "n.a.")
  end

  # GET /transactions/1/edit
  def edit
    Rails.cache.clear
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        Rails.cache.clear
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        Rails.cache.clear
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      Rails.cache.clear
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:membership_id, :status_message, :status, :entry_date, :amount, :currency, :sender, :description)
  end
end
