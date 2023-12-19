module Api
    module V1
      class ChatsController < ApplicationController
        before_action :set_application
        before_action :set_chat, only: [:show, :update, :destroy]
  
        # GET /applications/:application_token/chats
        def index
          @chats = @application.chats
          render json: {data: @chats.as_json(except: [:id, :application_id])}
        end
  
        # GET /applications/:application_token/chats/:number
        def show
          render json: {data: @chat.as_json(except: [:id, :application_id])}
        end
  
        # POST /applications/:application_token/chats
        def create
          ChatCreateWorker.perform_async(@application.id, chat_params_create.to_hash.to_json)
          render json: { message: "Chat creation initiated" }, status: :accepted
          rescue StandardError => e
            render json: { error: e.message }, status: :unprocessable_entity
        end
  
        # PUT /applications/:application_token/chats/:number
        def update
          ChatUpdateWorker.perform_async(@chat.id, chat_params_update.to_hash.to_json)
          render json: { message: "Chat update initiated" }, status: :accepted
          rescue StandardError => e
            render json: { error: e.message }, status: :unprocessable_entity
        end
  
        # DELETE /applications/:application_token/chats/:number
        def destroy
          ChatDestroyWorker.perform_async(@chat.id)
          render json: {message: "Chat deletion initiated"}
        end
  
        private
  
        def set_application
          @application = Application.find_by(token: params[:application_token])
          render json: { error: "Application not found" }, status: :not_found unless @application
        end
  
        def set_chat
          @chat = @application.chats.find_by(chat_number: params[:number])
          render json: { error: 'Chat not found' }, status: :not_found unless @chat
        end
        
        def chat_params_create
          return {"application_token": params[:application_token]}
        end

        def chat_params_update
            params.permit(:chat_number)
        end

      end
    end
  end