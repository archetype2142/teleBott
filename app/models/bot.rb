class Bot < ApplicationRecord
	has_many :groups, dependent: :destroy
	has_many :histories
  has_many :bot_errors

  before_create :clean_token!
  after_create :start_bot

  validates :token, presence: true
  validates_uniqueness_of :token
  after_update :frequency_change

  def frequency_change
    if saved_change_to_frequency?
      job = Sidekiq::Cron::Job.find cron_job_name

      enabled = job ? job.enabled? : false 
      
      if job
        job.disable!
        job.destroy
      end

      Sidekiq::Cron::Job.create(
        name: cron_job_name,
        cron: "*/#{self.frequency} * * * *", 
        class: 'MessageWorker',
        args: id
      )

      job = Sidekiq::Cron::Job.find cron_job_name

      if enabled
        job.enable!
        job.enque!
      else
        job.enable!
      end
    end
  end

  def clean_token!
    self.token = self.token.gsub("\n", "")&.gsub("\r", "")
  end

  def start_bot
    begin
      bot = TelegramBot.new(token: self.token)
      bot.setWebhook

      UpdateWorker.perform_async
    rescue => e
      BotError.create!(
        bot: self,
        message: e
      )
    end
  end
end

