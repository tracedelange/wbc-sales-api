class OrderQueriesController < ApplicationController
    skip_before_action :authorized, only: [:show]

    def show

        #get a list of each account that has made an order in the last n months.

        time_range = (Time.now.midnight - 3.month)..Time.now.midnight
        results = Account.joins(:orders).where('orders.sale_date' => time_range, hidden: false).distinct

        render json: results, each_serializer: OrderQuerySerializer, time_range: time_range

    end

    private


    def order_query_params

        params.permit(:month_range)

    end
    
    


end
