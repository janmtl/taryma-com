class StudiesController < ApplicationController
  before_filter :require_login, :except => [:index, :view]
  
  #admin actions
  
  def index
    if logged_in?
      @studies = Study.find(:all)
    else
      redirect_to :action => 'view', :id => Study.find(:first, :order => :position).id
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
    @study = Study.new(params[:study])

    if @study.save
      redirect_to @study, :notice => 'Study was successfully created. <a href="'+new_study_path+'" class="btn">Create another</a>'.html_safe
    else
      render :action => "new"
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
    if @study.update_attributes(params[:study])
      redirect_to @study, :notice => 'Study was successfully updated.'
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @study = Study.find(params[:id])
    @study.destroy
    redirect_to studies_url
  end

  #application actions
  
  def view
    @study = Study.find(params[:id], :order => :position)
    @base_path = 'studies/'+@study.id.to_s+'/view'
    @all_studies = Study.select(:id).order(:position).map{|c| c.id}
   
    #If this is not the first study, find the previous one
    @prev_study_id = (@all_studies.first == @study.id) ? nil : @all_studies[@all_studies.index(@study.id)-1]
    @next_study_id = (@all_studies.last == @study.id) ? nil : @all_studies[@all_studies.index(@study.id)+1]
  end
end
