class CreateMessages < ActiveRecord::Migration[7.1]
  def change

      create_table :messages do |t|
        t.references :chat
        t.string :application_token
        t.integer :chat_number
        t.integer :message_number
        t.text :body
  
        t.timestamps
    end
    add_index :messages, [:application_token, :chat_number, :message_number], unique: true
    add_index :messages, :message_number
    add_foreign_key :messages, :chats, column: :chat_id, primary_key: :id, on_delete: :cascade

  end
end
