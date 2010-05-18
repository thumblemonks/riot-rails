class RoomsController < ActionController::Base
  def index
    render :text => "foo"
  end

  def echo_params
    serialized_params = (params.keys - ["action"]).sort.map {|k| "#{k}=#{params[k]}" }.join(",")
    render :text => serialized_params
  end
end
