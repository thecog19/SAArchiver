require_relative 'imgur_helper'
require 'logger'
require 'fileutils'

class ImgurScanExistingThreads
    def scan_all(skip_list = [])
        logger = Logger.new('log/logfile.log')
        imgur_helper = ImgurHelper.new
        Sathread.all.each do |thread|
            # logger.debug('scan') { "Scanning thread #{thread.id}" }
            p "Scanning thread #{thread.thread_id} title: #{thread.title}"
            scan_specific_thread(thread.thread_id) unless skip_list.include?(thread.thread_id)
        end
    end

    def generate_skip_list
        arr = Dir.entries("/root/imgur_images").to_a
        arr.delete('.')
        arr.delete('..')
        arr.map! { |x| x.to_i }
        arr 
    end

    def delete_single_thread_images(thread_id)
        FileUtils.rm_rf("/root/imgur_images/#{thread_id}")
    end

    def delete_last_thread_images
        arr = generate_skip_list
        last_thread_id = arr.min
        delete_single_thread_images(last_thread_id)
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