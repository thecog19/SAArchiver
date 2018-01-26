class SathreadController < ApplicationController

	def index
		page = params[:page] || 1
		@sathreads = Sathread.all.order("created_at ASC").page(page)

		render :json => {threads: @sathreads, meta: {page: page, total: @sathreads.total_pages }} 
	
	end

	def show
		@sathread = Sathread.where(thread_id: params[:id]).first
		render :json => @sathread
		
	end

	def strict_search_for_thread
		page = params[:page] || 1
		@sathreads = Sathread.exact_search_for(params[:search_term]).order("created_at ASC").page(page)
		render :json => {threads: @sathreads, meta: {page: page, total: @sathreads.total_pages }} 
	end

	def fuzzy_search_for_thread
		page = params[:page] || 1
		@sathreads = Sathread.fuzzy_search_for(params[:search_term]).order("created_at ASC").page(page)
		render :json => {threads: @sathreads, meta: {page: page, total: @sathreads.total_pages }} 
	end

	def posts_in_thread_strict_search
		@results = Post.exact_search_for(params[:search_term]).where(thread_id: params[:thread_id])
		if(@results.empty?)
			render :json => []
		else
			page = params[:page] || 1
			@results.order("created_at ASC").page(page)
			render :json => {posts: @results, meta: {page: page, total: @results.total_pages }} 
			
		end
	end

	def user_in_thread_posts
		@user = User.where(user_id: params[:user_id]).first
		if(@user)
			@results = @user.posts.where(thread_id: params[:thread_id]).order("created_at ASC")
		else
			@results = nil
		end

		if(!@results || @results.empty?)
			render :json => []
		else
			page = params[:page] || 1
			@results.page(page)
			render :json => {posts: @results, meta: {page: page, total: @results.total_pages }} 
		end
	end

	def search_user_in_thread_posts
		page = params[:page] || 1
		@user = User.where(user_id: params[:user_id]).first
		unless @user
			render :json => {error: "user not found"}
			return
		end
			
		@posts = Post.where(thread_id: params[:thread_id]).where(user_id: @user.id)
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

	def posts_in_thread_fuzzy_search
		@results = Post.fuzzy_search_for(params[:search_term]).where(thread_id: params[:thread_id]).order("created_at ASC")
		if(@results.empty?)
			render :json => []
		else
			page = params[:page] || 1
			@results.page(page)
			render :json => {posts: @results, meta: {page: page, total: @results.total_pages }}
		end
	end
end
