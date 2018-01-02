class SathreadController < ApplicationController

	def index
		@sathreads = Sathread.all
		render :json => @sathreads
	end

	def show
		@sathread = Sathread.where(thread_id: params[:id])
		render :json => @sathread
	end
end
