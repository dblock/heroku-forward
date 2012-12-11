module Heroku
  module Forward
    module Errors
      class BackendFailedToStartError < HerokuForwardError
        def initialize
          super(compose_message("backend_failed_to_start"))
        end
      end
    end
  end
end
