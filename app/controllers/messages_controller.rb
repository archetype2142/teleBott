class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :bot

	def edit
		@bot = bot
		@old = History.where(bot_id: params[:id])
	end

	def new
	end

	def update
		bot.histories.create!(
			message: params[:old_message]
		)

		bot.update(
			message: params[:message]
		)

		redirect_to edit_message_path(params[:id])		
	end

	def destroy
		History.find(
			params[:history]
		).destroy

		redirect_to edit_message_path(params[:id])
	end

	private

	def bot
		bot ||= Bot.find(params[:id])
	end
end
