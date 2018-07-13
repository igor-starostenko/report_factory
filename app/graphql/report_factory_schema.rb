# frozen_string_literal: true

ReportFactorySchema = GraphQL::Schema.define do
  use GraphQL::Batch
  enable_preloading

  # mutation(Types::MutationType)
  query(Types::QueryType)
end
