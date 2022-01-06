class ProductsController < ApplicationController

    skip_before_action :authorized, only: [:map_query]


    def index
        render json: Product.all, status: :ok
    end


    def create
        newProduct = Product.create(product_params)
        if newProduct.valid?
            render json: newProduct, status: :created
        else
            
            render json: {'error' => newProduct.errors}, status: :unprocessable_entity
        end
    end

    def show
        product = Product.find_by(id: product_params[:id])
        if product
            render json: product, status: :ok
        else
            render json: {"error" => "Product not found"}, status: 404
        end
    end
    
    def update
        product = Product.find_by(id: product_params[:id])
        product.update(product_params)
        if product.valid?
            render json: product, status: :ok
        else
            render json: {"error" => product.errors}, status: :unprocessable_entity
        end
    end

    def destroy
        product = Product.find_by(id: product_params[:id])
        product.delete
        if product.destroyed?
            head :no_content
        else
            render json: {"error" => "Cannot delete product."}, status: :unprocessable_entity
        end
    end

    def map_query
        time_range = (Time.now.midnight - 3.month)..Time.now.midnight

        results = Product.joins(:orders).where('orders.sale_date' => time_range).distinct

        render json: results, each_serializer: ProductMapQuerySerializer
    end

    private

    def product_params
        params.permit(:id, :product_name)
    end
end
