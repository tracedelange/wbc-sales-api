class AccountsController < ApplicationController


    def index

    end


    def most_orders

        accounts = Account.joins(:orders).group('accounts.id').order('count(orders.id) DESC')

        render json: accounts

    end
end
