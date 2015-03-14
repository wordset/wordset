module Wordset
  module V1
    class Base < Grape::API
      include Wordset::V1::Defaults

      mount Wordset::V1::Activities
      mount Wordset::V1::Auth
      mount Wordset::V1::Messages
      mount Wordset::V1::Notifications
      mount Wordset::V1::Projects
      mount Wordset::V1::Proposals
      mount Wordset::V1::Users
      mount Wordset::V1::Votes
      mount Wordset::V1::Words
      mount Wordset::V1::WordLists


      add_swagger_documentation(
        api_version: "v1",
        base_path: "api",
        hide_documentation_path: true,
        mount_path: "/swagger_doc",
        hide_format: true
      )
    end
  end
end
