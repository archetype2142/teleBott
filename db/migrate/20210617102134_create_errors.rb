class CreateErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :bot_errors do |t|
      t.text :message

      t.timestamps
    end
  end
end
