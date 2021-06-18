class WebhookController < ApplicationController 
  skip_before_action :verify_authenticity_token, only: :create

  def create
    #useless request, pass it
    error_response unless params["my_chat_member"]

    bot = Bot.find_by(token: params[:id])
    
    #bot not found
    error_response unless bot

    status_param = params["my_chat_member"]["new_chat_member"]["status"]
    group_params = params["my_chat_member"]["chat"]

    bot_status = begin
      case status_param 
      when "left"
        false
      when "member"
        true
      else
        nil
      end
    end

    if bot_status.nil?
      report_error bot_id: bot.id, error_message: "Unknown bot status on the group"
      error_response
    end

    if bot_status #create a new group, add bot to it
      group = Group.new(
        name: group_params["title"],
        telegram_group_id: group_params["id"],
        bot_id: bot.id
      )

      unless group.save
        report_error bot_id: bot.id, error_message: group.errors
        error_response
      end
    else #remove bot from that group if it exists      
      group = bot.groups.find_by(telegram_group_id: group_params["id"])
      group.destroy! if group
    end

    bot.update name: params["my_chat_member"]["new_chat_member"]["user"]["username"] if bot.name.nil?  
    render json: {}, status: :ok
  end

  private

  #we  don't want webhook to keep sending requests, so we return a success  
  def error_response
    render json: {}, status: :ok && return
  end
end
