require_relative 'concerns/sa_scraper'
require 'logger'
class Sathread < ApplicationRecord
  belongs_to :user, :foreign_key => :op_id,  optional: true 
  has_many :posts, :primary_key => :thread_id, :foreign_key => :thread_id

  def self.refreshAllThreads
    logger = Logger.new('log/logfile.log')
    logger.info('refreshAllThreads') { "Begining to refresh all threads at time #{Time.now}" }
  	self.all.each do |thread|
  		newScraper = SAScraper.new
      begin 
  		  newScraper.main_logic(thread.last_page)
  	  rescue Exception => e
        logger.error('refreshAllThreads') { "An error caused thread with id #{thread.id} to fail to update, error was #{e.message} " }
      end
    end
  end 

  def self.newThread(url)
  	newScraper = SAScraper.new
  	newScraper.main_logic(url)
  end
end
