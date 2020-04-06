class PagesController < ApplicationController

  def index
    @ticker = Ticker.first
  end
end
