class ChatUpdateWorker
    include Sidekiq::Worker
    queue_as :default
  
    def perform(chat_id, params)
        hash_params = JSON.parse params
        @chat = Chat.find(chat_id)
        @chat.with_lock do
            if !@chat.update(hash_params)
                raise StandardError, @chat.errors
            end
        end
    end
    
end