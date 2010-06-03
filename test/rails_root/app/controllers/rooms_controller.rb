class RoomsController < ActionController::Base
  def index
    render :text => "foo"
  end

  def create
    render :text => "created #{params.inspect}"
  end

  def update
    render :text => "updated #{params.inspect}"
  end

  def destroy
    render :text => "destroyed #{params.inspect}"
  end

  def echo_params
    serialized_params = (params.keys - ["action"]).sort.map {|k| "#{k}=#{params[k]}" }.join(",")
    render :text => serialized_params
  end
end
