class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    
    before_validation :set_initial_message_number, on: :create

    belongs_to :chat

    validates :message_number, presence: true, uniqueness: { scope: [:chat_number, :application_token]}
    validates :body, presence: true

    # Specify the Elasticsearch index settings and mappings
    settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
        indexes :body, type: 'text', analyzer: 'english'
        end
    end

    private

    def set_initial_message_number
        self.message_number = (Message.where(chat_number: chat_number, application_token: application_token).maximum(:message_number) || 0) + 1
    end
end