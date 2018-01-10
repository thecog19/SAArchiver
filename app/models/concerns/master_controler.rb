require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require_relative 'sa_scraper'
require 'pp'
require 'logger'

logger = Logger.new('log/logfile.log')
a = SAScraper.new
target = 'https://forums.somethingawful.com/showthread.php?threadid=3550307&userid=0&perpage=40&pagenumber=1'

begin 
	p "starting"
	a.main_logic(target)
rescue Exception => e
	p e
	logger.error('master_controller') { "An error caused the specified thread #{target} to fail to update, error was #{e.inspect} #{e.to_s}" }
end
