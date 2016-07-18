require 'fileutils'

require File.expand_path('../../app/services/v1/system/seed_service.rb', __FILE__)

# FileUtils.rm(File.expand_path('../../log/seeds.log', __FILE__)) rescue nil

module NiftyServicesSamples
  module Seed
    module_function def init!
      puts "Seeding database, this can take a while..."
      Services::V1::System::SeedService.new(logger: Logger.new('log/seeds.log')).execute
      puts "Database seed finished!"
      puts "Database status"
      puts "Users = %s\nPosts = %s\nComments = %s" % [User.count, Post.count, Comment.count]
    end
  end
end

NiftyServicesSamples::Seed.init!