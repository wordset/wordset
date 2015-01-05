Grape::API.logger Padrino.logger

module WordsetData
  module API
    require File.expand_path('../v1.rb', __FILE__)

    class App < Grape::API
      class << self

        # Without this, we now get an error about undefined method include? for TrueClass
        def cascade
          []
        end

        def root
          @_root ||= File.expand_path('..', __FILE__)
        end

        def dependencies
          @_dependencies ||= [
            "v1.rb", "resources/*.rb"
          ].map { |file| Dir[File.join(self.root, file)] }.flatten
        end

        def load_paths
          @_load_paths ||= %w(models lib controllers).map { |path| File.join(self.root, path) }
        end

        def require_dependencies
          Padrino.set_load_paths(*load_paths)
        end

        def setup_application!
          return if @_configured
          self.require_dependencies
          Grape::API.logger = Padrino.logger
          @_configured = true
          @_configured
        end

        def app_file; ""; end
        def public_folder; ""; end
      end

      setup_application!

      before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
      end

      after { logger.info "API << #{env['REQUEST_METHOD']} #{env['PATH_INFO']}; errors: #{env["rack.errors"].inspect}" }

      mount ::WordsetData::API::V1

      add_swagger_documentation mount_path: "/swagger", base_path: "http://localhost:3000/api", api_version: "v1"

      #http://petstore.swagger.wordnik.com/
      # <== http://localhost:3000/api/swagger/global
   end
 end
end
