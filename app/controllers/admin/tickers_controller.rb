class Admin::TickersController < ApplicationController
  http_basic_authenticate_with name: Rails.application.credentials.admin[:username],
                               password: Rails.application.credentials.admin[:password]


  def index
    @ticker = Ticker.find_by base_currency: 'USD',
                             quote_currency: 'RUB'
  end


  def update
    @ticker = Ticker.find(params[:id])
    if @ticker.update ticker_params
      redirect_to admin_index_path, notice: 'Ticker was successfully updated.'
    else
      render :index, notice: @ticker.errors.full_messages.join('\n')
    end
  end

  def show
    @ticker = Ticker.find params[:id]
    render :index
  end


  private

  def ticker_params
    params.require(:ticker).permit(:price, :fixed_until)
  end
end