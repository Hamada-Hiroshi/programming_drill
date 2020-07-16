class StocksController < ApplicationController
  def create
    stock = current_user.stocks.build(app_id: params[:app_id])
    stock.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    stock = current_user.stocks.find_by(app_id: params[:app_id])
    stock.destroy
    redirect_back(fallback_location: root_path)
  end
end
