class StocksController < ApplicationController
  def create
    @app = App.find(params[:app_id])
    stock = current_user.stocks.build(app_id: params[:app_id])
    stock.save
  end

  def destroy
    @app = App.find(params[:app_id])
    stock = current_user.stocks.find_by(app_id: params[:app_id])
    stock.destroy
  end
end
