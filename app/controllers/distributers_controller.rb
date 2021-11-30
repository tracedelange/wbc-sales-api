class DistributersController < ApplicationController

    def index
        render json: Distributer.all, status: :ok
    end

    def show

        distributor = Distributer.find_by(id: distributorParams[:id])

        if distributor
            render json: distributor, status: :ok
        else
            rendr json: {"error": 'Distributor Not Found'}, status: 404
        end


    end


    private

    def distributorParams
        params.permit(:id)
    end
    
end
