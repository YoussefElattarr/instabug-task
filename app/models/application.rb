class Application < ApplicationRecord

    before_validation :generate_token, on: :create

    validates :token, presence: true, uniqueness: true
    validates :name, presence: true

    has_many :chats
    
    after_create :initialize_counts
  
    private
  
    def initialize_counts
      update(chats_count: 0)
    end

    def generate_token
        self.token = loop do
          random_token = SecureRandom.hex(16)
          break random_token unless self.class.exists?(token: random_token)
        end
    end
    
  end
  