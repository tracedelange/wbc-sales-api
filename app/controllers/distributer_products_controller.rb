class DistributerProductsController < ApplicationController

    def show
        @distributerProduct = DistributerProduct.find_by(id: distributer_products_params[:id])

        if @distributerProduct
            render json: @distributerProduct, status: :ok
        else
            render json: {error: 'Distributer Product does not exist'}, status: 404
        end
    end

    def update

        @distributerProduct = DistributerProduct.find_by(id: distributer_products_params[:id])
        @product = Product.find_by(id: distributer_products_params[:product_id])


        if @distributerProduct && @product

            @distributerProduct.update(product_id: distributer_products_params[:product_id])

            if @distributerProduct.valid?

                UnknownOrder.where(distributer_product_id: @distributerProduct.id).each do |unknown_order|
              
                    product = @distributerProduct.product
            
                    newOrder = Order.create(account_id: unknown_order.account_id, sale_date: unknown_order.sale_date, product_id: product.id)
            
                    if newOrder.valid?
                        unknown_order.delete
                    end
                  end

                render json: @distributerProduct, status: :ok
            else
                render json: {error: 'Distributer Product could not be assigned.'}, status: :unprocessable_entity
            end

        else
            render json: {error: 'Distributer Product does not exist'}, status: 404
        end

    end

    private

    def distributer_products_params
        params.permit(:id, :product_id)
    end
end
