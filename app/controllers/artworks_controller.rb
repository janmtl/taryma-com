class ArtworksController < ApplicationController
  before_action :authenticate_user!, except: [:browse, :recent, :view]
  helper_method :sort_column, :sort_direction
  
  #admin actions
  
  def index
    permitted_params = params.permit(:query)
    respond_to do |format|
      format.html { @artworks = Artwork.all }
      format.json {
        if permitted_params[:query]
          @artworks = Artwork.order(:title).where("title like ?", "%#{permitted_params[:query]}%")
        else
          @artworks = Artwork.order(:title)
        end
        render json: @artworks.map{|artwork| {:id => artwork.id, :name => artwork.title, :filename => artwork.filename_url(:modal).to_s}}
      }
    end
  end
  
  def new
    @artwork = Artwork.new
  end

  def create
    @artwork = Artwork.new(artwork_params)

    if @artwork.save
      redirect_to @artwork, notice: 'Artwork was successfully created. <a href="'+new_artwork_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
    end
  end
  
  def edit
    @artwork = Artwork.find(params[:id])
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update(artwork_params)
      redirect_to @artwork, notice: 'Artwork was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.destroy
    redirect_to artworks_url
  end
  
  #application actions
  
  def browse
    @artworks = Artwork.order(sort_column + " " + sort_direction).page(params[:page]).per(60)
    @base_path = 'artworks/browse'
    permitted_params = params.permit(:sort, :direction, :page)
    Rails.logger.debug "Permitted Params: #{permitted_params.inspect}"
    @filters = true
  end

  def recent
    @artworks = Artwork.order("catno DESC").is_recent.page(params[:page]).per(120)
    #@artworks = Artwork.find(:all, :order=>"catno DESC", :conditions => [ "recent = ?", 1]).page(params[:page]).per(60)
    @base_path = 'artworks/recent'
    permitted_params = params.permit(:sort, :direction)
    # Use `permitted_params` instead of `params` in your logic
    render 'browse'
  end

  def view
    @artwork = Artwork.find(params[:id])
  end

  private

  def sort_column
    Artwork.column_names.include?(params[:sort]) ? params[:sort] : "catno"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def artworks_to_csv(artworks)
    FasterCSV.generate do |csv| 
      csv << ["Title", "Year", "Technique", "x-cm", "y-cm", "x-inch", "y-inch", "Category", "Cat.No."]
      artworks.each do |artwork|
        csv << [artwork.title, artwork.date_created.strftime("%Y"), artwork.technique.name, artwork.xcm, artwork.ycm, artwork.xinch, artwork.yinch, artwork.category.name, artwork.catno]
      end
    end
  end

  def artwork_params
    params.require(:artwork).permit(:catno, :date_created, :filename, :recent, :title, :xcm, :xinch, :ycm, :yinch, :technique_id, :category_id, :recent, :sort, :direction, :page)
  end

  def permitted_params
    params.permit(:sort, :direction, :page)
  end
end
