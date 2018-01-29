class PostsController < ApplicationController

	def index
		page = params[:page] || 1
		@posts = Post.all.order("created_at ASC").page(page)
		render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
	end

	def show
		render :json => Post.where(id: params[:id])
	end

	def posts_by_user
		if(User.where(user_id: params[:user_id]).first)
			page = params[:page] || 1
			@posts = User.where(user_id: params[:user_id]).first.posts.order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		else
			render :json => {error: "user not found"} 
		end

	end

	def posts_by_thread
		if(Sathread.where(thread_id: params[:thread_id]).first)
			page = params[:page] || 1
			@posts = Sathread.where(thread_id: params[:thread_id]).first.posts.order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		else
			render :json => {error: "thread not found"} 
		end
		
	end

	def search_posts
		page = params[:page] || 1
		if(params[:search_type] == "fuzzy")
			@posts = Post.all.fuzzy_search_for(params[:search_term]).order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		else
			@posts = Post.all.exact_search_for(params[:search_term]).order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		end
	end

	def search_user_posts
		page = params[:page] || 1
		@user = User.where(user_id: params[:user_id]).first
		unless @user
			render :json => {error: "user not found"}
			return
		end
			
		@posts = Post.where(user_id: @user.id)
		if(params[:search_type] == "fuzzy")
			@posts = @posts.fuzzy_search_for(params[:search_term]).order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		elsif(params[:search_type] == "strict")
			@posts = @posts.exact_search_for(params[:search_term]).order("created_at ASC").page(page)
			render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
		else
			render :json => {error: "invalid search type"}
		end
	end

	def complex_query
		posts = Post
		paginate :json => Post.all and return unless(params[:query])
		if(params[:query][:fuzzysearch])
			params[:query][:fuzzysearch].each do |term|
				posts = posts.fuzzy_search_for(term)
			end
		end

		if(params[:query][:strictsearch])
			params[:query][:strictsearch].each do |term|
				posts = posts.fuzzy_search_for(term)
			end
		end

		if(params[:user_id])
			user_id = User.where(user_id: params[:user_id]).first.id
			posts = posts.where(user_id: user_id)
		end

		if(params[:thread_id])

			posts = posts.where(thread_id: params[:thread_id])
		end

		page = params[:page] || 1
		posts = posts.order("created_at ASC").page(page)
		render :json => {posts: posts, meta: {page: page, total: posts.total_pages }} 
	end

	
end
