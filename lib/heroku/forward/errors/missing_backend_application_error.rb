module Heroku
  module Forward
    module Errors
      class MissingBackendApplicationError < HerokuForwardError
        def initialize(path)
          super(compose_message("missing_backend_application", {
            :path => path
          }))
        end
      end
    end
  end
end
