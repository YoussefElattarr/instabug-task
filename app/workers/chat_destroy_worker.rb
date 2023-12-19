class ChatDestroyWorker
    include Sidekiq::Worker
    queue_as :default
  
    def perform(chat_id)
        @chat = Chat.find(chat_id)
        @chat.destroy
        decrement_chats_count
    end
    
    private 

    def decrement_chats_count
        @chat.application.decrement!(:chats_count)
    end

end