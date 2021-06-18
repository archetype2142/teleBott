class AddCronJobNameToBot < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :cron_job_name, :string
  end
end
