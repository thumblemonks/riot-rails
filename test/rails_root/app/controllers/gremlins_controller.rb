class GremlinsController < ActionController::Base
  def index
    render :text => "bar"
  end

  def show
    render :text => "show me the money"
  end

  def create
    render :text => "makin' money"
  end
end
