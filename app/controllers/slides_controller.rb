class SlidesController < ApplicationController
  before_action :authenticate_user!, except: [:browse]
  
  #admin actions
  
  def index
    @slides = Slide.order(:position)
  end
  
  def new
    @slide = Slide.new
  end

  def create
    @slide = Slide.new(slide_params)

    if @slide.save
      redirect_to @slide, notice: 'Slide was successfully created. <a href="'+new_slide_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
    end
  end
  
  def edit
    @slide = Slide.find(params[:id])
  end

  def show
    @slide = Slide.find(params[:id])
  end

  def update
    @slide = Slide.find(params[:id])
    if @slide.update(slide_params)
      redirect_to @slide, notice: 'Slide was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @slide = Slide.find(params[:id])
    @slide.destroy
    redirect_to slides_url
  end
  
  def sort
    params[:slide].each_with_index{|id, index|
      Slide.update_all({:position => (index+1)}, {:id => id})
    }
    render :nothing => true
  end
  
  #application actions
  
  def browse
    respond_to do |format|
      format.html { 
        @slides = Slide.order(:position) 
        @slide_interval = 2500
      }
      format.json {
        @slides = Slide.order(:position)
        render :json => @slides.map{|slide|{:image => slide.artwork.filename_url.to_s, :title => slide.artwork.title, :url => '#'}}
      }
    end
  end
  
  private
  
  def slide_params
    params.require(:slide).permit(:artwork_id, :position, :artwork_title)
  end
end
