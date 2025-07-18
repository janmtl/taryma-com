class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:browse]
  helper_method :sort_column, :sort_direction
  
  #admin actions
  
  def index
    @categories = Category.find(:all)
  end
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    
    #taken from http://apidock.com/rails/ActiveRecord/DeleteRestrictionError
    begin
      @category.destroy
      flash[:success] = "Category successfully deleted." 
    rescue ActiveRecord::DeleteRestrictionError => e
      @category.errors.add(:base, e)
      flash[:error] = "Category still contains artworks and could not be deleted."
    ensure
      redirect_to categories_url
    end
  end
  
  #application actions

  def browse
    @artworks = Category.find(params[:id]).artworks.order(sort_column + " " + sort_direction).page(params[:page]).per(60)
    @base_path = 'categories/'+params[:id]+'/browse'
    @filters = true
    @filter_title = Category.find(params[:id]).name
  end
  
  private

  def sort_column
    Artwork.column_names.include?(params[:sort]) ? params[:sort] : "catno"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def category_params
    params.require(:category).permit(:name, :position)
  end
end
