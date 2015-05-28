module Wordsets
  module V1
    class Base < Grape::API
      include Wordsets::V1::Defaults

      mount Wordsets::V1::Activities
      mount Wordsets::V1::Auth
      mount Wordsets::V1::Messages
      mount Wordsets::V1::Notifications
      mount Wordsets::V1::Langs
      mount Wordsets::V1::Posts
      mount Wordsets::V1::Projects
      mount Wordsets::V1::Proposals
      mount Wordsets::V1::Seqs
      mount Wordsets::V1::Users
      mount Wordsets::V1::Votes
      mount Wordsets::V1::Quizzes
      mount Wordsets::V1::WordLists
      mount Wordsets::V1::WordsetsApi

      Grape::Endpoint.send :include, Garner::Cache::Context


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
