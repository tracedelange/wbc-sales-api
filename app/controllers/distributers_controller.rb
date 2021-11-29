class DistributersController < ApplicationController

    def index
        render json: Distributer.all, status: :ok
    end
    
end
