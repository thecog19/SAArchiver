require 'logger'
require 'open-uri'

class ImgurHelper
    def initialize(image_file_path = "./imgur_images")
        @imgur_regex = /\bhttps?:\/\/(?:i\.)?imgur\.com\/(?:[a-zA-Z0-9]{7,}|[a-zA-Z0-9]{5,}|[a-zA-Z0-9]{3,})\b/
        @image_file_path = image_file_path
        @logger = Logger.new('log/logfile.log')
        create_directory_if_not_exists(@image_file_path)
    end

    def create_directory_if_not_exists(path)
        unless Dir.exist?(path)
          parent = File.dirname(path)
          create_directory_if_not_exists(parent) unless Dir.exist?(parent)
          Dir.mkdir(path)
        end
    end

    def save_images(body)
        imgur_urls = body.scan(@imgur_regex)
        imgur_urls.each do |url|
            failed = false
            p url
            sleep(0.1)
            try = 0
            while !failed
                begin
                    save_image(url)
                rescue Exception => e
                    if try < 10 
                        try += 1 
                    else
                        p "Failed to save image #{url}"
                        p "Error: #{e}"
                        failed = true
                    end
                end
            end
        end
    end

    def save_image(url)
        regex = %r{\bhttps?://(?:i\.)?imgur\.com/(?:(?:gallery/)?([a-zA-Z0-9]{1,})|\b([a-zA-Z0-9]{1,})(?:\.\w+)?)\b}
        imgur_id_and_extension = url.match(regex)
        imgur_id = imgur_id_and_extension[1] || imgur_id_and_extension[2]
        p "imgur_id: #{imgur_id}"
        imgur_extension = imgur_id_and_extension[3] || '.jpg'
        filename = "#{imgur_id}#{imgur_extension}"
        path = File.join(@image_file_path, filename)
        File.open(path, "wb") do |file|
            # @logger.debug('save_images') { "Saving image #{url} to #{path}" }
            url = url + '.jpg' if File.extname(url) == ''
            begin
                file.write(open(url).read)
            rescue Exception => e
                p "failed with error #{e}"
                raise e 
            end
        end
    end
end
