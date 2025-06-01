class TechniquesController < ApplicationController
  before_action :require_login, except: [:browse]
  helper_method :sort_column, :sort_direction
  
  #admin actions
  
  def index
    @techniques = Technique.all
  end
  
  def new
    @technique = Technique.new
  end

  def create
    @technique = Technique.new(technique_params)

    if @technique.save
      redirect_to @technique, notice: 'Technique was successfully created.'
    else
      render :new
    end
  end

  def edit
    @technique = Technique.find(params[:id])
  end

  def show
    @technique = Technique.find(params[:id])
  end

  def update
    @technique = Technique.find(params[:id])
    if @technique.update(technique_params)
      redirect_to @technique, notice: 'Technique was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @technique = Technique.find(params[:id])
    
    #taken from http://apidock.com/rails/ActiveRecord/DeleteRestrictionError
    begin
      @technique.destroy
      flash[:success] = "Technique successfully deleted." 
    rescue ActiveRecord::DeleteRestrictionError => e
      @technique.errors.add(:base, e)
      flash[:error] = "Technique still contains artworks and could not be deleted."
    ensure
      redirect_to techniques_url
    end
  end
  
  #application actions

  def browse
    @artworks = Technique.find(params[:id]).artworks.order("#{sort_column} #{sort_direction}").page(params[:page]).per(60)
    @base_path = "techniques/#{params[:id]}/browse"
    @filters = true
    @filter_title = Technique.find(params[:id]).name
  end
  
  private

  def sort_column
    Artwork.column_names.include?(params[:sort]) ? params[:sort] : "catno"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def technique_params
    params.require(:technique).permit(:name, :position)
  end
end
