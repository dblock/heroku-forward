module Heroku
  module Forward
    module Errors
      class MissingBackendOptionError < HerokuForwardError
        def initialize(name)
          super(compose_message("missing_backend_option", {
            :name => name
          }))
        end
      end
    end
  end
end
