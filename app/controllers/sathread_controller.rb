class SathreadController < ApplicationController

	def index
		@sathreads = Sathread.all
		paginate :json => @sathreads
	end

	def show
		@sathread = Sathread.where(thread_id: params[:id])
		paginate :json => @sathread
	end

	def strict_search
		@results = Post.exact_search_for(params[:search_term]).where(thread_id: params[:thread_id])
		if(@results.empty?)
			render :json => []
		else
			paginate :json => @results
		end
	end

	def user_in_thread_posts
		@user = User.where(user_id: params[:user_id]).first
		if(@user)
			@results = @user.posts.where(thread_id: params[:thread_id])
		else
			@results = nil
		end

		if(!@results || @results.empty?)
			render :json => []
		else
			paginate :json => @results
		end
	end

	def search_user_in_thread_posts
		@user = User.where(user_id: params[:user_id]).first
		unless @user
			render :json => {error: "user not found"}
			return
		end
			
		@posts = Post.where(thread_id: params[:thread_id]).where(user_id: @user.id)
		if(params[:search_type] == "fuzzy")
			paginate :json => @posts.fuzzy_search_for(params[:search_term])
		elsif(params[:search_type] == "strict")
			paginate :json => @posts.exact_search_for(params[:search_term])
		else
			render :json => {error: "invalid search type"}
		end
	end

	def fuzzy_search
		@results = Post.fuzzy_search_for(params[:search_term]).where(thread_id: params[:thread_id])
		if(@results.empty?)
			render :json => []
		else
			paginate :json => @results
		end
	end
end
