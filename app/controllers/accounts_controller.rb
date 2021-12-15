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

        account = Account.find_by(id: accounts_params[:id])

        if account

            account.update(accounts_params)

            if account.valid? 
                render json: account, status: :ok
            else
                render json: {'error' => account.errors}
            end


        else
            render json: {'error' => 'Account not found.'}, status: 404
        end

    end


 


    private

    def accounts_params
        params.permit(:id, :hidden, :display_name, :address, :city, :state, :latitude, :longitude)
    end


end
