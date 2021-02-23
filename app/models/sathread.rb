require_relative 'concerns/sa_scraper'
require_relative 'concerns/pdf_generator'
require 'logger'
class Sathread < ApplicationRecord
  include PgSearch 
  logger = Logger.new('log/logfile.log')
  belongs_to :op, :class_name => "User", :foreign_key => :op_id,  optional: true 
  has_many :posts, :primary_key => :thread_id, :foreign_key => :thread_id, dependent: :destroy

  def self.refreshAllThreads
    logger.info('refreshAllThreads') { "Begining to refresh all threads" }
    newScraper = SAScraper.new
  	self.all.each do |thread|
      sleep(60)
      begin 
        newScraper.main_logic(thread.last_page)
  	  rescue Exception => e
        logger.error('refreshAllThreads') { "An error caused thread with id #{thread.id} to fail to update, error was #{e.message} " }
      end
    end
  end 

  def self.newThread(url, title)
    logger.info('newThread') { "Adding new thread, with title #{title} and url #{url}" }
    begin
    	newScraper = SAScraper.new
    	thread = newScraper.main_logic(url)
      thread.update(title: title)
    rescue Exception => e
      p e
      logger.error('newThread') { "An error caused thread with #{url} to fail to update, error was #{e.message} " }
    end
  end

  def self.pdfThread(id)
    logger.info('pdf') { "Generating a pdf of thread with id #{id}" }
    # begin 
      PdfGenerator.new(id)
    # rescue Exception => e
      # p e
      # logger.error('newThread') { "An error caused the thread #{id} to not generate a pdf, error was #{e.message} " }
    # end
    
  end

  pg_search_scope :exact_search_for, against: %i(title)
  pg_search_scope :fuzzy_search_for, against: %i(title), :using => { :tsearch => {:prefix => true, :dictionary => "english"}}
end
