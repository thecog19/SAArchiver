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

	
end
