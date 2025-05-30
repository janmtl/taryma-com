class HomeController < ApplicationController
  before_action :require_login

  def index
    @studies_count = Study.count
    @artworks_count = Artwork.count
    @pages_count = Page.count
  end

  def regenerate
  end

  def report
    @artworks = {}
    @images = {}

    Artwork.all.each do |artwork|
      begin
        @artworks[artwork.id] = { title: artwork.title, filename: "#{Rails.root}/public/#{artwork.filename}", exists: '', status: 'Regeneration started' }
        unless artwork.filename.file.exists?
          @artworks[artwork.id][:exists] = 'no'
          FileUtils.mkdir("#{Rails.root}/public/uploads/artwork/filename/#{artwork.id}/")
          FileUtils.cp("#{Rails.root}/public/gallery/#{artwork.catno}.jpg", "#{Rails.root}/public/uploads/artwork/filename/#{artwork.id}/")
        end
        @artworks[artwork.id][:exists] = 'yes'
        artwork.filename.recreate_versions!
        @artworks[artwork.id] = { title: artwork.title, filename: "#{Rails.root}/public/#{artwork.filename}", exists: 'yes', status: 'Regeneration completed' }
      rescue Exception => e
        @artworks[artwork.id][:status] = "Regeneration failed, error: #{e.message}"
      end
    end

    Image.all.each do |image|
      begin
        @images[image.id] = { filename: image.filename, status: 'Regeneration started' }
        image.filename.recreate_versions!
        @images[image.id] = { filename: image.filename, status: 'Regeneration completed' }
      rescue Exception => e
        @images[image.id][:status] = "Regeneration failed, error: #{e.message}"
      end
    end
  end

  def export
    artworks_to_csv(Artwork.all)
  end

  private

  def artworks_to_csv(artworks)
    csv_string = CSV.generate do |csv|
      csv << ["Title", "Year", "Technique", "x-cm", "y-cm", "x-inch", "y-inch", "Category", "Cat.No."]
      artworks.each do |artwork|
        csv << [artwork.title, artwork.date_created.strftime("%Y"), artwork.technique.name, artwork.xcm, artwork.ycm, artwork.xinch, artwork.yinch, artwork.category.name, artwork.catno]
      end
    end

    send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: "attachment; filename=artworks.csv"
  end
end