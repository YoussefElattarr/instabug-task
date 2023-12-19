class CreateChats < ActiveRecord::Migration[7.1]
  def change

      create_table :chats do |t|
        t.references :application
        t.string :application_token
        t.integer :chat_number
        t.integer :messages_count, default: 0
  
        t.timestamps
    end

    add_index :chats, [:application_token, :chat_number], unique: true
    add_index :chats, :chat_number
    add_foreign_key :chats, :applications, column: :application_id, primary_key: :id, on_delete: :cascade
  end
end
