
require 'logger'
class PdfGenerator 
  def initialize(id, size = 20)
    @logger = Logger.new('log/logfile.log')
    @thread = Sathread.where(id: id).first
    @size = size
    generate_pdf()
    
  end

  def generate_pdf
    count = 1
    page = @thread.posts.page(count).per(@size)
    while !page.last_page?
      pdf_file = ""
      page.each do |post|
        user = User.where(id: post.user_id).first
        pdf_file += "<h3>" + user.name + "</h3>"
        pdf_file += post.body
        pdf_file += "<br> <br> <hr>"
      end
      pdf_saver(pdf_file, @thread.title + " " + count.to_s + ".pdf")
      count += 1
      page = @thread.posts.page(count).per(@size)
    end
  end

  def pdf_saver(html, name)
    #update this path to not be hardcorded
    return PDFKit.new(html, :page_size => 'Letter')  
    .to_file("/home/felipe/programing/SAArchiver/pdfs/#{name}")
  end

end