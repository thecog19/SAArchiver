class PostsController < ApplicationController

	def index
		page = params[:page] || 1
		@posts = Post.all.order("created_at ASC").page(page)
		render :json => {posts: @posts, meta: {page: page, total: @posts.total_pages }} 
	end

	def show
		render :json => Post.where(id: params[:id])
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
