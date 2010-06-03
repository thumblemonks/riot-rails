class PartiesController < ActionController::Base
  def show
    render :text => "woot"
  end

  def create
    render :text => "give this monkey what he wants"
  end

  def update
    render :text => "i'll put that over here"
  end
end
