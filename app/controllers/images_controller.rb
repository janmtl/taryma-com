class ImagesController < ApplicationController
  before_action :require_login, except: [:view]
  
  #admin actions
  
  def index
    respond_to do |format|
      format.html { @images = Image.find(:all) }
      format.json {
        if params[:query]
          @images = Image.order(:filename).where("filename like ?", "%#{params[:filename]}%")
        else
          @images = Image.order(:filename)
        end
        render :json => @images.map{|image| {:id => image.id, :name => File.basename(image.filename_url), :filename => image.filename_url(:modal).to_s}}
      }
    end
  end
  
  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      redirect_to @image, notice: 'Image was successfully created. <a href="'+new_image_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
    end
  end
  
  def edit
    @image = Image.find(params[:id])
  end

  def show
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update(image_params)
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to images_url
  end
  
  #application actions
  def view
    @image = Image.find(params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:filename, :description)
  end
end
