class MessageUpdateWorker
    include Sidekiq::Worker
    queue_as :default
  
    def perform(message_id, params)
        hash_params = JSON.parse params
        @message = Message.find(message_id)
        @message.with_lock do
            if !@message.update(hash_params)
                raise StandardError, @message.errors
            end
        end
    end
    
end