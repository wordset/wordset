module WordsetData
  module API
    class App < Grape::API
      require_relative 'v1'
      include PadrinoGrape

      before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
      end

      after do
        logger.info "API << #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
        #if env["rack.errors"].any?
        #  logger.error "errors: #{env["rack.errors"].inspect}"
        #end
      end

      mount ::WordsetData::API::V1

      add_swagger_documentation mount_path: "/swagger", base_path: "http://localhost:3000/api", api_version: "v1"

      #http://petstore.swagger.wordnik.com/
      # <== http://localhost:3000/api/swagger/global
   end
 end
end
