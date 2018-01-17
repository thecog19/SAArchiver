class PostsController < ApplicationController

	def index
		@posts = Post.all
		paginate :json => @posts
	end

	def show
		render :json => Post.where(id: params[:id])
	end

	def posts_by_thread
		if(Sathread.where(thread_id: params[:thread_id]).first)
			@posts = Sathread.where(thread_id: params[:thread_id]).first.posts
			paginate :json => @posts
		else
			render :json => {error: "thread not found"} 
		end
		
	end

	def by_thread_with_user
		if(Sathread.where(thread_id: params[:thread_id]).first)
			@posts = Sathread.includes([:user]).where(thread_id: params[:thread_id]).first.posts
			paginate :json => @posts
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

		paginate :json => posts
	end

	
end
