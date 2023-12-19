class MessageCreateWorker
  include Sidekiq::Worker
  queue_as :default

  def perform(application_id, chat_id, params)
    hash_params = JSON.parse params
    @application = Application.find(application_id)
    @chat = @application.chats.find(chat_id)
    @message = @chat.messages.build(hash_params)
    increment_messages_count
    if !@message.save
      raise StandardError, @message.errors
    end
  end

  private 

  def increment_messages_count
    @message.chat.increment!(:messages_count)
  end

end