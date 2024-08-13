class ImagesController < ApplicationController
  before_action :require_authentication
  before_action :set_image, only: %i[show edit update destroy]

  def index
    @images = Image.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @image = Image.new
  end

  def edit
  end

  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        @image.set_url if @image.file.attached? && @image.url.blank?
        format.html { redirect_to image_url(@image), notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if update_image
        format.html { redirect_to image_url(@image), notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_image
    @image = Image.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to images_url, alert: "Image not found."
  end

  def image_params
    params.require(:image).permit(:name, :file)
  end

  def update_image
    @image.assign_attributes(image_params.except(:file))
    
    if image_params[:file].present?
      @image.file.attach(image_params[:file])
      @image.set_url
    end

    @image.save
  end
end
