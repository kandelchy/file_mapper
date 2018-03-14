class FieldsController < ApplicationController

  require 'yaml'
  require 'json'

  before_action :set_field, only: [:show, :edit, :update, :destroy]

  def import
    Field.import_first_file(params[:file])
    redirect_to root_url, notice: "Headers imported."
  end

  def import2
    Field.import_second_file(params[:file2])
    redirect_to root_url, notice: "Headers imported."
  end

  def save_yaml
    #save mapping data to .yml file
    unless File.exists?('file_mapping.yml')
      File.new('file_mapping.yml', 'w+')
    end
    data = YAML.load_file('file_mapping.yml') || {}
    key = Field.all
    key.each do |k|
      if k.head2.empty?
        puts "**********************"
        puts "Empty fields are not allowed"
        puts "**********************"
      else
        data[k.head1] = k.head2
      end
    end
    File.open("file_mapping.yml", 'w') do |f|
      f.write data.to_yaml
    end
  end

  def update_multiple
    # Add validation before update

    data =  params[:fields].values
    # if data.detect{ |e| data.count(e) > 1 }
    # data.each do |k,v|
      # print k, "   ", v
    # if data.map { |k,v| v }.uniq
      # puts "**********************"
      # puts data.detect{ |e| data.count(e) > 1 }
      # puts  data.uniq {|e| e[:head2] }
      # puts "There is a duplicate value"
    # end
    # puts "**********************"
    # data.each do |k,v|
    #   if v.nil?
    #     puts "**********************"
    #     puts "Empty fields are not allowed"
    #     puts "**********************"
    #   end
    # end

    @fields = Field.update(params[:fields].keys, params[:fields].values)
    @fields.reject! { |p| p.errors.empty? }
    if @fields.empty?
      save_yaml
      redirect_to fields_url
    else
      render "edit_multiple"
    end
  end

  # GET /fields/1/edit
  def edit
  end

  # Edit multiple records
  def edit_multiple
    @fields = Field.all
  end

  # GET /fields
  # GET /fields.json
  def index
    @fields = Field.all
  end

  # GET /fields/1
  # GET /fields/1.json
  def show
  end

  # GET /fields/new
  def new
    @field = Field.new
  end

  # POST /fields
  # POST /fields.json
  def create
    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        format.html { redirect_to @field, notice: 'Field was successfully created.' }
        format.json { render :show, status: :created, location: @field }
      else
        format.html { render :new }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fields/1
  # PATCH/PUT /fields/1.json
  def update
    respond_to do |format|
      if @field.update(field_params)
        format.html { redirect_to @field, notice: 'Field was successfully updated.' }
        format.json { render :show, status: :ok, location: @field }
      else
        format.html { render :edit }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /fields/1
  # DELETE /fields/1.json
  def destroy
    @field.destroy
    respond_to do |format|
      format.html { redirect_to fields_url, notice: 'Field was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field
      @field = Field.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_params
      params.require(:field).permit(:head1, :head2)
    end
end
