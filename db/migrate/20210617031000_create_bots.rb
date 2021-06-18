class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.text :token
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
