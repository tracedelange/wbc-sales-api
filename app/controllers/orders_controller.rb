class OrdersController < ApplicationController

    def index

        if order_params[:account_id]
            account = Account.find(order_params[:account_id])
            if account 
                render json: account.orders.order('sale_date DESC'), status: :ok
            else
                render json: {"error" => "Account not found."}, status: 404
            end
        else
            orders = Order.all
            render json: orders, status: :ok
        end



    end

    def show

    end


    private


    def order_params
        params.permit(:account_id)
    end

end
