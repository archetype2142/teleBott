class MessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false    

  def perform bot_id
    bot = Bot.find(bot_id)

    tb = ::TelegramBot.new(token: bot.token)

    bot.groups.each do |group|
      tb.sendMessage(
        bot.message,
        group.telegram_group_id
      )
    end
  end
end
