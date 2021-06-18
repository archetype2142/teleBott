class CronJobController < ApplicationController
  before_action :authenticate_user!
  before_action :bot

  def start
    job = Sidekiq::Cron::Job.find bot.cron_job_name

    if bot.cron_job_name.nil? || !job
      bot.update(cron_job_name: bot.token.split(":")[0])

      Sidekiq::Cron::Job.create(
        name: bot.cron_job_name || bot.token.split(":")[0], 
        cron: "*/#{bot.frequency} * * * *", 
        class: 'MessageWorker',
        args: bot.id
      )
    end
    
    job = Sidekiq::Cron::Job.find bot.cron_job_name
    job.enable!
    job.enque!

    redirect_to request.referer, flash: { success: "Job started!" }
  end

  def stop
    job = Sidekiq::Cron::Job.find bot.cron_job_name

    job.disable!
  end

  private
  
  def bot
    bot ||= Bot.find(params[:id])
  end
end
