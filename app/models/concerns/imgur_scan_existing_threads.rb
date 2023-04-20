require_relative 'imgur_helper'
require 'logger'

class ImgurScanExistingThreads
    def scan_all
        logger = Logger.new('log/logfile.log')
        imgur_helper = ImgurHelper.new
        Post.all.each do |post|
            logger.debug('scan') { "Scanning post #{post.id}" }
            imgur_helper.save_images(post.body)
        end
    end

    def scan_specific_thread(thread_id)
        logger = Logger.new('log/logfile.log')
        imgur_helper = ImgurHelper.new
        Post.where(thread_id: thread_id).each do |post|
            logger.debug('scan') { "Scanning post #{post.id}" }
            imgur_helper.save_images(post.body)
        end
    end
end