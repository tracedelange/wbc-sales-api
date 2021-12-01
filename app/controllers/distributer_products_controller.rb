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
