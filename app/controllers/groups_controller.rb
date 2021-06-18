class GroupsController < ApplicationController
  before_action :authenticate_user!

	def destroy
		Group.find(params[:group]).delete
		redirect_to bot_path(params[:id])
	end
end