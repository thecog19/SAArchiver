class UsersController < ApplicationController

	def fuzzy_search
		page = params[:page] || 1
		@user = User.prefix_search_for(params[:search_term]).page(page)

		render :json => {users: @user, meta: {page: page, total: @user.total_pages }} 
	end

	def strict_search
		page = params[:page] || 1
		@user = User.exact_search_for(params[:search_term]).page(page)

		paginate :json => {users: @user, meta: {page: page, total: @user.total_pages }} 
	end

	def show
		render :json => User.where(user_id: params[:id])
	end

	def show_internal_id
		render :json => User.where(id: params[:id])
	end

	def index
		page = params[:page] || 1
		@user = User.all.page(page)

		paginate :json => {users: @user, meta: {page: page, total: @user.total_pages }} 
	end

	def all_users
		render :json => User.all
	end
end
