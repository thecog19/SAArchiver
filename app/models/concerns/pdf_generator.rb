
require 'logger'
class PdfGenerator 
  def initialize(id, size = 2000)
    @logger = Logger.new('log/logfile.log')
    @thread = Sathread.where(id: id).first
    @size = size
    generate_pdf()
    
  end

  def generate_pdf
    count = 1
    page = @thread.posts.order('id ASC').page(count).per(@size)
    while !page.out_of_range?
      p "Page #{count}"
      pdf_file = """
      <!DOCTYPE html>
      <html>
      <head>
          <meta charset='utf-8'>
      </head>
      """
      page.each do |post|
        p post.id
        user = User.where(id: post.user_id).first
        pdf_file += "<h3>" + user.name + "</h3>"
        pdf_file += post.body
        pdf_file += "<br> <br> <hr>"
      end
      pdf_file += "</html>"
      begin  
        pdf_saver(pdf_file, @thread.title + " " + count.to_s + ".pdf")
      rescue Exception => e
        @logger.info('pdf') { "pdf error #{e}" }
      end
      count += 1
      page = @thread.posts.order('id ASC').page(count).per(@size)
    end
  end

  def pdf_saver(html, name)
    #update this path to not be hardcorded
    p name
    PDFKit.configure do |config|
      config.default_options[:ignore_load_errors] = true
      config.default_options[:quiet] = false
    end
    return PDFKit.new(html, :page_size => 'Letter')  
    .to_file("/home/felipe/programing/SAArchiver/pdfs/#{name}")
  end

end