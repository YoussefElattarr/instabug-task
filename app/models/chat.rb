class Chat < ApplicationRecord
    
    before_validation :set_initial_number, on: :create

    belongs_to :application
    has_many :messages

    validates :chat_number, presence: true, uniqueness: { scope: :application_token }
  
    private
    
    def set_initial_number
        self.chat_number = (Chat.where(application_token: application_token).maximum(:chat_number) || 0) + 1
    end

  end
  