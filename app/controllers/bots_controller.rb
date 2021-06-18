class BotsController < ApplicationController
	before_action :authenticate_user!
	before_action :bot, only: %i[update show destroy]

	def new; end

	def index
		@bots = Bot.all
	end

	def create
		new_bot = Bot.new(bot_params)

		if new_bot.save
			redirect_to bot_path, flash: { success: "bot created!" }
		else
			redirect_to new_bot_path, flash: { error: new_bot.errors }
		end
	end

	def update
		if bot.update bot_params
			redirect_to bot_path(bot), flash: { success: "bot updated successully" }
		else
			redirect_to bot_path(bot), flash: { error: bot.errors }
		end
	end

	def show
		@bot = bot
		@groups = bot.groups
	end

	def destroy
		if bot.destroy
			redirect_to root_path, flash: { success: "bot deleted successully" }
		else
			redirect_to root_path, flash: { error: bot.errors }
		end
	end

	private 

	def bot
		bot ||= Bot.find(params[:id])
	end

	def bot_params
		params.require(:bot).permit(
			:token,
			:message,
			:frequency
		)
	end
end
