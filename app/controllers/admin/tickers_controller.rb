class Admin::TickersController < ApplicationController
  http_basic_authenticate_with name: Rails.application.credentials.admin[:username],
                               password: Rails.application.credentials.admin[:password]


  def index
    @ticker = Ticker.find_by base_currency: 'USD',
                             quote_currency: 'RUB'
  end


  def update
    @ticker = Ticker.find(params[:id])
    @ticker.price = ticker_params[:price]
    @ticker.fixed_until = ticker_params[:fixed_until]
    if @ticker.save
      redirect_to admin_index_path, notice: 'Ticker was successfully updated.'
    else
      render :index
    end
  end


  private

  def ticker_params
    params.fetch(:ticker, [:price, :fixed_until])
  end
end