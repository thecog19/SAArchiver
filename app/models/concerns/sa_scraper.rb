#HAVE TO GET ASSOCIATIONS WORKING

class SAScraper 
  def initialize
    @agent = Mechanize.new
    @thread_id = nil
    @fist_post = nil
    @last_post = nil
  end

  def main_logic(thread)
    page = login(thread)
    time = Time.now
    @thread_id = get_thread_id(page).to_i
    thread = create_thread(@thread_id)
    if(thread.last_page)
      page = @agent.get(thread.last_page)
    end
    loop do
      sleep(0.5)
      posts = get_posts(page)
      page_on = page.uri.to_s.split("&").last[11..-1]
      p "Page #{page_on}"
      break unless page.link_with(:text => '›')
      page = page.link_with(:text => '›').click
    end
    update_thread_with_posts(page.uri.to_s)
    time_now = Time.new
    puts "total run time #{time_now - time}"
  end

  def update_thread_with_posts(finalURL)
    thread = Sathread.where(thread_id: @thread_id).first
    thread.last_post_id = @last_post
    unless thread.first_post_id
      thread.op_id = Post.where(id: @first_post).first.user_id
      thread.first_post_id = @first_post
    end
    thread.last_page = finalURL
    thread.save
  end

  def login(thread_given)
    my_page = @agent.get(thread_given)
    login_page = @agent.click(my_page.link_with(:text => /LOG IN/))
    my_page = login_page.form_with(:action => 'https://forums.somethingawful.com/account.php')
    my_page.fields[1].value = ENV["sausername"]
    my_page.fields[2].value = ENV["sapassword"]
    my_page.click_button
  end

  def get_thread_id(page)
     thread_id = page.parser.at('div#thread').attributes['class']
     thread_id.to_s[7..-1]
  end

  def sanitize(page)
    posts = page.parser.css("table")
    posts.xpath('//comment()').each { |comment| comment.remove }
    posts.search('p.editedby').each { |p| p.remove }
    posts
    
  end

  def get_posts(page)
    posts = sanitize(page)
    posts.each do |post|
      user = create_user(post)
      post_record = create_post(post, user)
      unless @first_post
        @first_post = post_record.id
      end
      @last_post = post_record.id

    end
  end

  def create_thread(thread_id)
    if Sathread.where(thread_id: thread_id).empty?
      thread = Sathread.new(thread_id: thread_id)
      thread.save
    else 
      thread = Sathread.where(thread_id: thread_id)
    end
    thread.first
  end

  def create_user(post)
    if User.where(name: get_data(post, "dt.author").text.to_s).empty?

      user = User.new(name: get_data(post, "dt.author").text.to_s, 
             reg_date: get_data(post, "dd.registered").text.to_s,
             quote: get_data(post, "dd.title").text.to_s,
             image: post.css("div.bbc-center").css("img.img").to_s,
             user_id: post.css("td.userinfo").first["class"].split(" ")[1][7..-1]
             )
      user.save
      
      unless Sathread.where(thread_id: @thread_id).first.nil?
        if Sathread.where(thread_id: @thread_id).first.posts.empty?
          Sathread.where(thread_id: @thread_id).first.update(op_id: user.id) 
        end
      end

      user
    else 
      User.where(name: get_data(post, "dt.author").text.to_s).first
    end
  end

  def create_post(post, user)
    if Post.where(post_id: (post.attributes["id"].to_s)[4..-1]).empty?
      new_post = Post.new(body: get_data(post, "td.postbody").to_s,
                          user_id: user.id, 
                          thread_id: @thread_id, 
                          post_id: (post.attributes["id"].to_s)[4..-1] )
      new_post.save
    end
    Post.where(post_id: (post.attributes["id"].to_s)[4..-1]).first
  end

  def get_post_id(post)
    (post.attributes["id"].to_s)[4..-1]
  end

  def get_data(post, target)
    post.css(target)
  end
end