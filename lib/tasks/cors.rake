namespace :cors do
  desc "Configure CORS for Hetzner Object Storage bucket"
  task setup: :environment do
    require 'aws-sdk-s3'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com-public'
    
    # CORS configuration
    cors_config = {
      cors_rules: [
        {
          allowed_headers: ['*'],
          allowed_methods: ['GET', 'HEAD'],
          allowed_origins: [
            'https://taryma.com',
            'https://www.taryma.com',
            'https://app.taryma.com',  # Update with your actual domain
            'http://localhost:3000',   # For development
            'http://127.0.0.1:3000'    # For development
          ],
          expose_headers: ['ETag'],
          max_age_seconds: 3600
        }
      ]
    }
    
    begin
      # Apply CORS configuration
      s3_client.put_bucket_cors(
        bucket: bucket,
        cors_configuration: cors_config
      )
      
      puts "✅ CORS configuration applied successfully!"
      puts "📋 Allowed origins:"
      cors_config[:cors_rules][0][:allowed_origins].each do |origin|
        puts "   - #{origin}"
      end
      
    rescue => e
      puts "❌ Failed to configure CORS: #{e.message}"
      puts "💡 Make sure your Hetzner credentials are configured correctly."
    end
  end
  
  desc "View current CORS configuration"
  task view: :environment do
    require 'aws-sdk-s3'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com-public'
    
    begin
      response = s3_client.get_bucket_cors(bucket: bucket)
      
      puts "📋 Current CORS configuration for bucket '#{bucket}':"
      puts "=" * 50
      
      response.cors_rules.each_with_index do |rule, index|
        puts "Rule #{index + 1}:"
        puts "  Allowed Methods: #{rule.allowed_methods.join(', ')}"
        puts "  Allowed Origins: #{rule.allowed_origins.join(', ')}"
        puts "  Allowed Headers: #{rule.allowed_headers.join(', ')}"
        puts "  Exposed Headers: #{rule.expose_headers.join(', ')}" if rule.expose_headers.any?
        puts "  Max Age: #{rule.max_age_seconds} seconds"
        puts
      end
      
    rescue => e
      puts "❌ Failed to retrieve CORS configuration: #{e.message}"
      puts "💡 The bucket might not have CORS configured yet."
    end
  end
  
  desc "Remove CORS configuration"
  task remove: :environment do
    require 'aws-sdk-s3'
    
    # Configure S3 client for Hetzner
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://hel1.your-objectstorage.com',
      access_key_id: Rails.application.credentials.dig(:hetzner, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:hetzner, :secret_access_key),
      region: 'hel1',
      force_path_style: true
    )
    
    bucket = 'taryma-com-public'
    
    begin
      s3_client.delete_bucket_cors(bucket: bucket)
      puts "✅ CORS configuration removed successfully!"
      
    rescue => e
      puts "❌ Failed to remove CORS configuration: #{e.message}"
    end
  end
end
