class FieldsController < ApplicationController

  require 'yaml'
  require 'json'

  before_action :set_field, only: [:show, :edit, :update, :destroy]

  def import
    Field.import_first_file(params[:file])
    redirect_to map_file_fields_path, notice: "Headers imported."
  end

  def import2
    Field.import_second_file(params[:file2])
    redirect_to map_file_fields_path, notice: "CSV file imported."
  end

  def import3
    Field.import_map_file(params[:file3])
    # redirect_to map_file_fields_path, notice: "YAML file uploaded"
  end

  def import4
    Field.import_fourth_file(params[:file4])
    redirect_to fields_path, notice: "New CSV file created"
  end

  def save_yaml
    #save mapping data to .yml file
    File.new('file_mapping.yml', 'w+')
    data = YAML.load_file('file_mapping.yml') || {}
    key = Field.all
    key.each do |k|
      if k.head2.empty?

      else
        data[k.head1] = k.head2
      end
    end
    File.open("file_mapping.yml", 'w') do |f|
      f.write data.to_yaml
    end
  end


  def update_multiple
    data =  params[:fields].values
    error_message=''
    # Check if a field was left empty
    data.each do |k|
      if k['head2'].blank?
        error_message= "All fields should be mapped"
      end
    end
    #Check if one field was selected more than once
    data =  params[:fields].values
    if data.detect{ |e| data.count(e) > 1 }
      data.each do |k,v|
        if data.map { |k,v| v }.uniq
          error_message='Duplicate values detected'
        end
      end
    end
    @fields = Field.update(params[:fields].keys, params[:fields].values)
    if  error_message.blank? #@fields.empty? &&
      save_yaml
      redirect_to fields_url, notice: "File saved successfully"
    else
      flash[:notice] = error_message
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
