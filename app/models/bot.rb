class Bot < ApplicationRecord
	has_many :groups, dependent: :destroy
	has_many :histories
  has_many :bot_errors

  after_create :start_bot
  after_update :frequency_change
  before_create :clean_token!
  before_destroy :clean_jobs

  validates :token, presence: true
  validates_uniqueness_of :token

  def clean_jobs
    job = Sidekiq::Cron::Job.find(token.split(":")[0])

    job.disable!
    job.destroy
  end

  def frequency_change
    if saved_change_to_frequency?
      job = Sidekiq::Cron::Job.find(token.split(":")[0])

      enabled = job ? job.enabled? : false 
      
      if job
        job.disable!
        job.destroy
      end

      Sidekiq::Cron::Job.create(
        name: token.split(":")[0],
        cron: "*/#{self.frequency} * * * *", 
        class: 'MessageWorker',
        args: id
      )

      job = Sidekiq::Cron::Job.find token.split(":")[0]

      if enabled == true
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

