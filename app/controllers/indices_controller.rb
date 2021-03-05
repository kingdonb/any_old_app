class IndicesController < ApplicationController
  before_action :set_index, only: %i[ show edit update destroy ]

  # GET /indices or /indices.json
  def index
    @indices = Index.all
  end

  # GET /indices/1 or /indices/1.json
  def show
  end

  # GET /indices/new
  def new
    @index = Index.new
  end

  # GET /indices/1/edit
  def edit
  end

  # POST /indices or /indices.json
  def create
    @index = Index.new(index_params)

    respond_to do |format|
      if @index.save
        format.html { redirect_to @index, notice: "Index was successfully created." }
        format.json { render :show, status: :created, location: @index }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indices/1 or /indices/1.json
  def update
    respond_to do |format|
      if @index.update(index_params)
        format.html { redirect_to @index, notice: "Index was successfully updated." }
        format.json { render :show, status: :ok, location: @index }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1 or /indices/1.json
  def destroy
    @index.destroy
    respond_to do |format|
      format.html { redirect_to indices_url, notice: "Index was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index
      @index = Index.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def index_params
      params.fetch(:index, {})
    end
end
