require_relative 'imgur_helper'
require 'logger'

class ImgurScanExistingThreads
    def scan_all
        logger = Logger.new('log/logfile.log')
        imgur_helper = ImgurHelper.new
        Sathread.all.each do |thread|
            # logger.debug('scan') { "Scanning thread #{thread.id}" }
            p "Scanning thread #{thread.thread_id} title: #{thread.title}"
            scan_specific_thread(thread.thread_id)
        end
    end

    def scan_specific_thread(thread_id)
        logger = Logger.new('log/logfile.log')
        imgur_helper = ImgurHelper.new("/root/imgur_images/#{thread_id}")
        Post.where(thread_id: thread_id).find_each do |post|
            logger.debug('scan') { "Scanning post #{post.id}" }
            imgur_helper.save_images(post.body)
        end
    end
end