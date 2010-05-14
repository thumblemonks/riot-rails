module RiotRails
  module ActionController
    class ControllerMismatch < Exception; end

    module HttpMethods
      def get(uri, params={}, &block)
        env['action_dispatch.request.path_parameters'] = {:action => action_for_uri(uri)}
        current_session.get(uri, params, env, &block)
      end
    private
      def action_for_uri(uri)
        controller_name = controller.controller_name
        recognized_path = Rails.application.routes.recognize_path(uri)

        return recognized_path[:action] if controller_name == recognized_path[:controller]

        error_msg = "Expected %s controller, not %s"
        raise ControllerMismatch, error_msg % [controller_name, recognized_path[:controller]]
      end
    end # HttpMethods
  end # ActionController
end # RiotRails
