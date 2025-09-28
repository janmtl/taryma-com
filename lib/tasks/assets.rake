namespace :assets do
  desc "Upload static assets to Hetzner Object Storage"
  task upload_to_hetzner: :environment do
    require 'aws-sdk-s3'
    require 'find'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com'
    public_dir = Rails.root.join('public')
    
    puts "🚀 Starting upload of static assets to Hetzner Object Storage..."
    
    # Upload all files from public directory
    Find.find(public_dir) do |path|
      next if File.directory?(path)
      
      relative_path = path.sub("#{public_dir}/", '')
      
      # Skip Rails-specific files and directories
      next if relative_path.start_with?('assets/') # Skip compiled assets (handled separately)
      next if relative_path == '.keep'
      
      begin
        content_type = case File.extname(path).downcase
        when '.css'
          'text/css'
        when '.js'
          'application/javascript'
        when '.png'
          'image/png'
        when '.jpg', '.jpeg'
          'image/jpeg'
        when '.gif'
          'image/gif'
        when '.svg'
          'image/svg+xml'
        when '.ico'
          'image/x-icon'
        when '.xml'
          'application/xml'
        when '.txt'
          'text/plain'
        else
          'application/octet-stream'
        end
        
        # Upload file to S3
        s3_client.put_object(
          bucket: bucket,
          key: relative_path,
          body: File.read(path),
          content_type: content_type,
          cache_control: 'public, max-age=31536000' # 1 year cache
        )
        
        puts "✅ Uploaded: #{relative_path}"
        
      rescue => e
        puts "❌ Failed to upload #{relative_path}: #{e.message}"
      end
    end
    
    puts "🎉 Static assets upload completed!"
  end
  
  desc "Upload compiled assets (JS/CSS) to Hetzner Object Storage"
  task upload_compiled_assets: :environment do
    require 'aws-sdk-s3'
    require 'find'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com'
    assets_dir = Rails.root.join('public', 'assets')
    
    unless Dir.exist?(assets_dir)
      puts "❌ Assets directory not found. Run 'rails assets:precompile' first."
      exit 1
    end
    
    puts "🚀 Starting upload of compiled assets to Hetzner Object Storage..."
    
    Find.find(assets_dir) do |path|
      next if File.directory?(path)
      
      relative_path = path.sub("#{Rails.root.join('public')}/", '')
      
      begin
        content_type = case File.extname(path).downcase
        when '.css'
          'text/css'
        when '.js'
          'application/javascript'
        when '.png'
          'image/png'
        when '.jpg', '.jpeg'
          'image/jpeg'
        when '.gif'
          'image/gif'
        when '.svg'
          'image/svg+xml'
        when '.ico'
          'image/x-icon'
        else
          'application/octet-stream'
        end
        
        # Upload file to S3 with fingerprint in filename for cache busting
        s3_client.put_object(
          bucket: bucket,
          key: relative_path,
          body: File.read(path),
          content_type: content_type,
          cache_control: 'public, max-age=31536000' # 1 year cache
        )
        
        puts "✅ Uploaded compiled asset: #{relative_path}"
        
      rescue => e
        puts "❌ Failed to upload #{relative_path}: #{e.message}"
      end
    end
    
    puts "🎉 Compiled assets upload completed!"
  end
  
  desc "Clean up old assets from Hetzner Object Storage"
  task cleanup_old_assets: :environment do
    require 'aws-sdk-s3'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com'
    
    puts "🧹 Cleaning up old assets from Hetzner Object Storage..."
    
    begin
      # List all objects in the bucket
      response = s3_client.list_objects_v2(bucket: bucket)
      
      current_assets = Dir.glob(Rails.root.join('public', 'assets', '*')).map do |path|
        File.basename(path)
      end
      
      deleted_count = 0
      
      response.contents.each do |object|
        next unless object.key.start_with?('assets/')
        
        filename = File.basename(object.key)
        
        # If this asset file doesn't exist locally, delete it from S3
        unless current_assets.any? { |asset| asset.include?(filename.split('-').first) }
          s3_client.delete_object(bucket: bucket, key: object.key)
          puts "🗑️  Deleted old asset: #{object.key}"
          deleted_count += 1
        end
      end
      
      puts "🧹 Cleanup completed! Deleted #{deleted_count} old asset files."
      
    rescue => e
      puts "❌ Failed to cleanup old assets: #{e.message}"
    end
  end
  
  desc "Full asset deployment: precompile and upload to Hetzner"
  task deploy_to_hetzner: :environment do
    puts "🚀 Starting full asset deployment to Hetzner Object Storage..."
    
    # Precompile assets
    puts "📦 Precompiling assets..."
    Rake::Task['assets:precompile'].invoke
    
    # Upload static files
    puts "📁 Uploading static files..."
    Rake::Task['assets:upload_to_hetzner'].invoke
    
    # Upload compiled assets
    puts "⚙️  Uploading compiled assets..."
    Rake::Task['assets:upload_compiled_assets'].invoke
    
    # Cleanup old assets
    puts "🧹 Cleaning up old assets..."
    Rake::Task['assets:cleanup_old_assets'].invoke
    
    puts "🎉 Full asset deployment completed!"
  end
end
