# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'

class TelegramBot
  InvalidRequest = Class.new(StandardError)

  BASE_URI="https://api.telegram.org/bot"
  
  attr_accessor :token
  attr_reader :request_url, :bot_id, :webhook_url

  def initialize token: nil
    @token = token
    @request_url = BASE_URI + token + "/"
    @bot_id = token.split(":")[0]
  end

  def setWebhook
    webhook_url = ENV['HOST'] + @token
    uri = URI(
      @request_url + 
      "setWebhook" + 
      "?url=" +
      webhook_url +
      "&allowed_updates=%5B%22my_chat_member%22%5D"
    )
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      @webhook_url = webhook_url
    else
      raise InvalidRequest.new(JSON.parse(res.body))
    end
  end

  def sendMessage message, chat_id
    message = CGI.escape message
    uri = URI(
      @request_url + 
      "sendMessage" +
      "?chat_id=" +
      chat_id.to_s + 
      "&text=" +
      message
    )

    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      JSON.parse res.body
    else
      raise InvalidRequest.new(JSON.parse(res.body))
    end
  end
end
