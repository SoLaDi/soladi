class DistributionPointsController < ApplicationController
  before_action :set_distribution_point, only: [:show, :edit, :update, :destroy]

  # GET /distribution_points
  # GET /distribution_points.json
  def index
    @distribution_points = DistributionPoint.all
  end

  # GET /distribution_points/1
  # GET /distribution_points/1.json
  def show
  end

  # GET /distribution_points/new
  def new
    @distribution_point = DistributionPoint.new
  end

  # GET /distribution_points/1/edit
  def edit
  end

  # POST /distribution_points
  # POST /distribution_points.json
  def create
    @distribution_point = DistributionPoint.new(distribution_point_params)

    respond_to do |format|
      if @distribution_point.save
        format.html { redirect_to @distribution_point, notice: 'Distribution point was successfully created.' }
        format.json { render :show, status: :created, location: @distribution_point }
      else
        format.html { render :new }
        format.json { render json: @distribution_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distribution_points/1
  # PATCH/PUT /distribution_points/1.json
  def update
    respond_to do |format|
      if @distribution_point.update(distribution_point_params)
        format.html { redirect_to @distribution_point, notice: 'Distribution point was successfully updated.' }
        format.json { render :show, status: :ok, location: @distribution_point }
      else
        format.html { render :edit }
        format.json { render json: @distribution_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distribution_points/1
  # DELETE /distribution_points/1.json
  def destroy
    @distribution_point.destroy
    respond_to do |format|
      format.html { redirect_to distribution_points_url, notice: 'Distribution point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution_point
      @distribution_point = DistributionPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def distribution_point_params
      params.require(:distribution_point).permit(:name, :street, :housenumber, :zipcode, :city, :person_id)
    end
end
