require_relative '../config/environment'
ActiveRecord::Base.logger = Logger.new(nil)

# File to contain CLI and to run

cli = App.new

cli.run

