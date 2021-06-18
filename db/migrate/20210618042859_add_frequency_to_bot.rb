class AddFrequencyToBot < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :frequency, :integer, default: 5
  end
end
