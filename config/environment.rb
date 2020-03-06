require 'bundler'
Bundler.require

ActiveRecord::Base.logger = nil

require_all 'lib'

require_relative '../db/seeds.rb'
