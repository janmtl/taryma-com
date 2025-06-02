class StudiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :view]
  
  #admin actions
  
  def index
    if user_signed_in?
      @studies = Study.all
    else
      redirect_to action: 'view', id: Study.order(:position).first.id
    end
  end
  
  def new
    @study = Study.new
    1.times { 
      @study.attachments.build 
      @study.image_attachments.build
    }
  end

  def create
    @study = Study.new(study_params)

    if @study.save
      redirect_to @study, notice: 'Study was successfully created. <a href="'+new_study_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
    end
  end
  
  def edit
    @study = Study.find(params[:id])
  end

  def show
    @study = Study.find(params[:id])
  end

  def update
    @study = Study.find(params[:id])
    if @study.update(study_params)
      redirect_to @study, notice: 'Study was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @study = Study.find(params[:id])
    @study.destroy
    redirect_to studies_url
  end

  #application actions
  
  def view
    # @study = Study.find(params[:id], :order => :position)
    @study = Study.find(params[:id])
    @base_path = 'studies/'+@study.id.to_s+'/view'
    @all_studies = Study.select(:id).order(:position).map{|c| c.id}
   
    #If this is not the first study, find the previous one
    @prev_study_id = (@all_studies.first == @study.id) ? nil : @all_studies[@all_studies.index(@study.id)-1]
    @next_study_id = (@all_studies.last == @study.id) ? nil : @all_studies[@all_studies.index(@study.id)+1]
  end

  private
  
  def study_params
    params.require(:study).permit(:description, :name, :position, attachments_attributes: [:id, :artwork_id, :_destroy], image_attachments_attributes: [:id, :image_id, :_destroy])
  end
end
