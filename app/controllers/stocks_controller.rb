class StocksController < ApplicationController
  def create
    @app = App.find(params[:app_id])
    stock = current_user.stocks.build(app_id: params[:app_id])
    stock.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @app = App.find(params[:app_id])
    stock = current_user.stocks.find_by(app_id: params[:app_id])
    stock.destroy
    respond_to do |format|
      format.js
    end
  end
end
