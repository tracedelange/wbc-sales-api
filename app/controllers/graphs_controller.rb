class GraphsController < ApplicationController


    def search

        # byebug;

        @product = Product.find_by(id: graphs_params[:product_id])

        if @product

            data = graph_orders            
            render json: graph_orders_month_chunks, status: :ok

        else
            render json: {'error' => "Product not found"}, status: 404
        end

    end


    private

    def graph_orders
        # getSelf
        @orders = Order.where(product_id: @product.id).group('sale_date').order('sale_date ASC').count
        
        result = {}
        (@orders.first[0]..Date.today()).each do |date|
            # Do stuff with date
            # byebug;
            if @orders[date] != nil
                result[date] = @orders[date]
            else 
                result[date] = 0
            end
        end
        result
    end
    
    def graph_orders_month_chunks
        @orders = Order.where(product_id: @product.id).group('sale_date').order('sale_date ASC').count
        results = {
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 0,
            10 => 0,
            11 => 0,
            12 => 0
        }

        @orders.each do |order|

            # pp order[0].month

            # pp order[1]

            results[order[0].month] = order[1] + results[order[0].month]

            # results = {**results, order[0].month => results[order[0].month] + results[order[1]]}
        end

        results
    end
    

    def graphs_params
        params.permit(:product_id)
    end


end
