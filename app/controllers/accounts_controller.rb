class AccountsController < ApplicationController

    


    def show #returns detailed information about a specific selected accounts
        @account = Account.find_by(id: accounts_params[:id])
        if @account
            render json: @account, status: :ok
        else
            render json: {error: 'Account not found.'}, status: 404
        end

    end

    def update

    end


 


    private

    def accounts_params
        params.permit(:page, :id)
    end


end
