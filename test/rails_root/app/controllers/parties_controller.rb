class PartiesController < ActionController::Base
  def show
    render :text => "woot"
  end

  def create
    puts params.inspect
    render :text => "give this monkey what he wants"
  end
end
