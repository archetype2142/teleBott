class ErrorsController < ApplicationController
  before_action :authenticate_user!

	def index
		@errors = BotError.all
	end

	def destroy
		BotError.find(params[:id]).delete
		redirect_to errors_index_path
	end

end