class AddErrorsToBot < ActiveRecord::Migration[6.1]
  def change
    add_reference :bot_errors, :bot, index: true
  end
end
