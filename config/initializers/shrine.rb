# frozen_string_literal: true

require 'shrine'

case Rails.env
when 'development'
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  }
when 'test'
  require 'shrine/storage/memory'

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  require 'shrine/storage/s3'

  s3_options = {
    bucket: Rails.application.credentials.bucket[:name],
    region: Rails.application.credentials.aws[:region],
    access_key_id: Rails.application.credentials.aws[:access_key_id],
    secret_access_key: Rails.application.credentials.aws[:secret_access_key]
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'uploads/cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'uploads', **s3_options)
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation
Shrine.plugin :validation_helpers
