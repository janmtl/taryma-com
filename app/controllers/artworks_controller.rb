class ArtworksController < ApplicationController
  before_filter :require_login, :except => [:browse, :recent, :view]
  helper_method :sort_column, :sort_direction
  
  #admin actions
  
  def index
    respond_to do |format|
      format.html { @artworks = Artwork.find(:all) }
      format.json {
        if params[:query]
          @artworks = Artwork.order(:title).where("title like ?", "%#{params[:query]}%")
        else
          @artworks = Artwork.order(:title)
        end
        render :json => @artworks.map{|artwork| {:id => artwork.id, :name => artwork.title, :filename => artwork.filename_url(:modal).to_s}}
      }
    end
  end
  
  def new
    @artwork = Artwork.new
  end

  def create
    @artwork = Artwork.new(params[:artwork])

    if @artwork.save
      redirect_to @artwork, :notice => 'Artwork was successfully created. <a href="'+new_artwork_path+'" class="btn">Create another</a>'.html_safe
    else
      render :action => "new"
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
    if @artwork.update_attributes(params[:artwork])
      redirect_to @artwork, :notice => 'Artwork was successfully updated.'
    else
      render :action => "edit"
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
    @filters = true
  end

  def recent
    @artworks = Artwork.order("catno DESC").is_recent.page(params[:page]).per(120)
    #@artworks = Artwork.find(:all, :order=>"catno DESC", :conditions => [ "recent = ?", 1]).page(params[:page]).per(60)
    @base_path = 'artworks/recent'
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
end
