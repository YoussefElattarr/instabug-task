module Api
    module V1
      class MessagesController < ApplicationController
        before_action :set_application, :set_chat
        before_action :set_message, only: [:show, :update, :destroy]
  
        # GET /applications/:application_token/chats/:chat_number/messages
        def index
          @messages = @chat.messages
          render json: {data: @messages.as_json(except: [:id, :application_id, :chat_id])}
        end

        # GET /applications/:application_token/chats/:chat_number/messages/search?q:[query_text]
        def search
          @query = params[:q]
          @results = @chat.messages.__elasticsearch__.search(
          query: {
            wildcard: {
              body: {
                  value: "*#{@query}*",
                  boost: 1.0,
                  rewrite: "constant_score_blended"
              }
            }
          },
          ).records

          render json: {data: @results.as_json(except: [:id, :application_id, :chat_id])}
        end

        # GET /applications/:application_token/chats/:chat_number/messages/:message_number
        def show
          render json: {data: @message.as_json(except: [:id, :application_id, :chat_id])}
        end
  
        # POST /applications/:application_token/chats/:chat_number/messages
        def create
          MessageCreateWorker.perform_async(@application.id, @chat.id, message_params_create.to_hash.to_json)
          render json: { message: "Message creation initiated" }, status: :accepted
          rescue StandardError => e
            render json: { error: e.message }, status: :unprocessable_entity
        end
  
        # PUT /applications/:application_token/chats/:chat_number/messages/:message_number
        def update
          MessageUpdateWorker.perform_async(@message.id, message_params_update.to_hash.to_json)
          render json: { message: "Message update initiated" }, status: :accepted
          rescue StandardError => e
            render json: { error: e.message }, status: :unprocessable_entity
        end
  
        # DELETE /applications/:application_token/chats/:chat_number/messages/:message_number
        def destroy
          MessageDestroyWorker.perform_async(@message.id)
          render json: {message: "Message deletion initiated"}
        end
  
        private
        def set_application
            @application = Application.find_by(token: params[:application_token])
            render json: { error: "Application not found" }, status: :not_found unless @application
        end

        def set_chat
          @chat = @application.chats.find_by(chat_number: params[:chat_number])
          render json: { error: 'Chat not found' }, status: :not_found unless @chat
        end
  
        def set_message
          @message = @chat.messages.find_by(message_number: params[:message_number])
          render json: { error: 'Message not found' }, status: :not_found unless @message
        end
  
        def message_params_create
          params.require(:message).permit(:body).merge(application_token: params[:application_token], chat_number: params[:chat_number])
        end

        def message_params_update
            params.require(:message).permit([:body, :message_number])
          end
      end
    end
  end