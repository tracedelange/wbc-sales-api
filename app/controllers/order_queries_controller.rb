class OrderQueriesController < ApplicationController


    def show



        #get a list of each account that has made an order in the last n months.

        time_range = (Time.now.midnight - Integer(order_query_params[:month_range]).month)..Time.now.midnight
        results = Account.joins(:orders).where('orders.sale_date' => time_range).distinct

        render json: results, each_serializer: OrderQuerySerializer, time_range: time_range

    end

    private


    def order_query_params

        params.permit(:month_range)

    end
    
    


end
