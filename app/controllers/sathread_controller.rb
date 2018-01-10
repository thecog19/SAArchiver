class SathreadController < ApplicationController

	def index
		@sathreads = Sathread.all
		paginate :json => @sathreads
	end

	def show
		@sathread = Sathread.where(thread_id: params[:id])
		paginate :json => @sathread
	end
end
