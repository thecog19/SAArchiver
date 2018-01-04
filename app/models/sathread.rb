require_relative 'concerns/sa_scraper'
class Sathread < ApplicationRecord
  belongs_to :user, :foreign_key => :op_id,  optional: true 
  has_many :posts, :primary_key => :thread_id, :foreign_key => :thread_id

  def self.refreshAllThreads
  	self.all.each do |thread|
  		newScraper = SAScraper.new
  		newScraper.main_logic(thread.last_page)
  	end
  end 

  def self.newThread(url)
  	newScraper = SAScraper.new
  	newScraper.main_logic(url)
  end
end
