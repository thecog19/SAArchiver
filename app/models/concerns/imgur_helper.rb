require 'logger'
require 'open-uri'

class ImgurHelper
    def initialize(image_file_path = "./imgur_images")
        @imgur_regex = /\bhttps?:\/\/(?:i\.)?imgur\.com\/(?:[a-zA-Z0-9]{7}|[a-zA-Z0-9]{5}|[a-zA-Z0-9]{3,})\b/
        @image_file_path = image_file_path
        @logger = Logger.new('log/logfile.log')
        create_directory_if_not_exists(@image_file_path)
    end

    def create_directory_if_not_exists(path)
        unless Dir.exist?(path)
            Dir.mkdir(path)
        end
    end

    def save_images(body)
        imgur_urls = body.scan(@imgur_regex)
        imgur_urls.each do |url|
            save_image(url)
        end
    end

    def save_image(url)
        imgur_id = url.match(/\/([a-zA-Z0-9]{5,})(\.[a-zA-Z0-9]{3,4})?/)[1]
        imgur_extension = url.match(/\/([a-zA-Z0-9]{5,})(\.[a-zA-Z0-9]{3,4})?/)[2] || ".jpg"
        filename = "#{imgur_id}#{imgur_extension}"
        path = File.join(@image_file_path, filename)
        File.open(path, "wb") do |file|
            @logger.debug('save_images') { "Saving image #{url} to #{path}" }
            file.write(open(url).read)
        end
    end
end