require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Rake::Task['db:environment:set'].invoke
  Rake::Task["db:reset"].invoke
  ActiveRecord::Base.logger = Logger.new(nil)
  Pry.start
end
