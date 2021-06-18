class ApplicationController < ActionController::Base
  def report_error bot_id: nil, error_message: nil
    BotError.create!(
      bot_id: bot_id,
      message: error_message
    )
  end
end
