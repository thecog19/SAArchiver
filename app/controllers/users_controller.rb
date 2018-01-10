class UsersController < ApplicationController

	def fuzzy_search
		paginate :json => User.prefix_search_for(params[:search_term])
	end

	def strict_search
		paginate :json => User.exact_search_for(params[:search_term])
	end

	def show
		render :json => User.where(user_id: params[:id])
	end

	def index
		paginate :json => User.all
	end
end
