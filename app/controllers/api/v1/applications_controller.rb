module Api
  module V1
    class ApplicationsController < ApplicationController
    
        before_action :set_application, only: [:show, :update, :destroy]

        # GET /applications
        def index
            @applications = Application.all
            render json:{data: @applications.as_json(except: :id)}
        end
    
        # GET /applications/:token
        def show
            render json: {data: @application.as_json(except: :id)}
        end
    
        # POST /applications
        def create
            @application = Application.new(application_params)
            if @application.save
                render json: {message: "Application created successfully", data: @application.as_json(except: :id)}, status: :created
            else
                render json: @application.errors, status: :unprocessable_entity
            end
        end
    
        # PUT /applications/:token
        def update
        if @application.update(application_params)
            render json: {message: "Application updated successfully", data: @application.as_json(except: :id)}
        else
            render json: @application.errors, status: :unprocessable_entity
        end
        end
    
        # DELETE /applications/:token
        def destroy
            @application.destroy
            render json: {message: "Application deleted successfully"}
        end
    
        private
    
        def set_application
            @application = Application.find_by(token: params[:token])
            render json: { error: 'Application not found' }, status: :not_found unless @application
        end
    
        def application_params
            params.permit(:name)
        end

    end
  end
end
