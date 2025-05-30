class HomeController < ApplicationController
  before_filter :require_login

  def index
    @studies_count = Study.count
    @artworks_count = Artwork.count
    @pages_count = Page.count
  end
  
  def regenerate
  end
  
  def report
    
    @artworks = Hash.new()
    @images = Hash.new()
    
    Artwork.find(:all).each do |artwork|
      begin
        @artworks[artwork.id] = {:title => artwork.title, :filename => "#{Rails.root.to_s}/public/#{artwork.filename}", :exists => '', :status => 'Regeneration started'}
        if !artwork.filename.file.exists?
          @artworks[artwork.id][:exists] = 'no'
          FileUtils.mkdir("#{Rails.root.to_s}/public/uploads/artwork/filename/#{artwork.id}/")
          FileUtils.cp("#{Rails.root.to_s}/public/gallery/#{artwork.catno}.jpg", "#{Rails.root.to_s}/public/uploads/artwork/filename/#{artwork.id}/")
        end
        @artworks[artwork.id][:exists] = 'yes'
        artwork.filename.recreate_versions!
        @artworks[artwork.id] = {:title => artwork.title, :filename => "#{Rails.root.to_s}/public/#{artwork.filename}", :exists => 'yes', :status => 'Regeneration completed'}
      rescue Exception => e
        @artworks[artwork.id][:status] = 'Regeneration failed, error: '+e.message
      end
    end

    Image.find(:all).each do |image|
      begin
        @images[image.id] = {:filename => image.filename, :status => 'Regeneration started'}
        image.filename.recreate_versions!
        @images[image.id] = {:filename => image.filename, :status => 'Regeneration completed'}
      rescue Exception => e
        @images[image.id][:status] = 'Regeneration failed, error'+e.message
      end
    end
  end

  def export
    artworks_to_csv(Artwork.find(:all))
  end
  
  private
  
  def artworks_to_csv(artworks)
    csv_string = CSV.generate do |csv| 
      csv << ["Title", "Year", "Technique", "x-cm", "y-cm", "x-inch", "y-inch", "Category", "Cat.No."]
      artworks.each do |artwork|
        csv << [artwork.title, artwork.date_created.strftime("%Y"), artwork.technique.name, artwork.xcm, artwork.ycm, artwork.xinch, artwork.yinch, artwork.category.name, artwork.catno]
      end
    end
    
    send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=artworks.csv" 
  end
  
#  
#  def exodus
#    @artworks = Hash.new()
#    
#    Artwork.find(:all).each do |artwork|
#      begin
#        @artworks[artwork.id] = {:title => nil, :from => nil, :to => nil, :status => nil}
#        @artworks[artwork.id][:title] = artwork.title
#        @artworks[artwork.id][:from] = '/home/yan/dev/remote_local/public/gallery/'+File.basename(artwork.filename_url)
#        @artworks[artwork.id][:to] = '/home/yan/dev/remote_local/public/uploads/artwork/filename/'+artwork.id.to_s+'/'
#        @artworks[artwork.id][:status] = 'Copy started<br/>'.html_safe
#        
#        @artworks[artwork.id][:status] += File.file?(@artworks[artwork.id][:from]) ? 'Source file exists<br/>'.html_safe : 'Source file does not exist<br/>'.html_safe
#        @artworks[artwork.id][:status] += File.directory?(@artworks[artwork.id][:to]) ? 'Target directory exists<br/>'.html_safe : 'Target directory does not exist<br/>'.html_safe
#        
#        FileUtils.mkdir(@artworks[artwork.id][:to]) unless File.directory?(@artworks[artwork.id][:to])
#        FileUtils.cp @artworks[artwork.id][:from], @artworks[artwork.id][:to]
#        
#        @artworks[artwork.id][:status] += 'Copy completed<br/>'.html_safe
#      rescue Exception => e
#        @artworks[artwork.id][:status] += 'Copy failed, error: '.html_safe+e.message
#      end
#    end
#  end
end