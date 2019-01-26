# frozen_string_literal: true

ReportFactorySchema = GraphQL::Schema.define do
  use GraphQL::Batch
  enable_preloading

  resolve_type ->(_record, obj, _ctx) { "#{obj.class.name}Type".constantize }

  # mutation(Types::MutationType)
  query(Types::QueryType)
end
