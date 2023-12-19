class ChatCreateWorker
    include Sidekiq::Worker
    queue_as :default
  
    def perform(application_id, params)
      hash_params = JSON.parse params
      @application = Application.find(application_id)
      @chat = @application.chats.build(hash_params)
      initialize_counts
      if !@chat.save
        raise StandardError, @chat.errors
      end
    end

    private 

    def initialize_counts
        @chat.update(messages_count: 0)
        @chat.application.increment!(:chats_count)
    end

end