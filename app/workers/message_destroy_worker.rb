class MessageDestroyWorker
    include Sidekiq::Worker
    queue_as :default
  
    def perform(message_id)
        @message = Message.find(message_id)
        @message.destroy
        decrement_messages_count
    end
    
    private 

    def decrement_messages_count
        @message.chat.decrement!(:messages_count)
    end

end