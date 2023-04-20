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
        regex = %r{\bhttps?://(?:i\.)?imgur\.com/(?:(?:gallery/)?([a-zA-Z0-9]{5,7})|\b([a-zA-Z0-9]{7})(?:\.\w+)?)\b}
        imgur_id_and_extension = url.match(regex)
        imgur_id = imgur_id_and_extension[1] || imgur_id_and_extension[2]
        imgur_extension = imgur_id_and_extension[3]&.sub('.', '') # Remove the leading period from the extension
        filename = "#{imgur_id}.#{imgur_extension}"
        path = File.join(@image_file_path, filename)
        File.open(path, "wb") do |file|
            @logger.debug('save_images') { "Saving image #{url} to #{path}" }
            file.write(open(url).read)
        end
    end
end