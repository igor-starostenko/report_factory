# frozen_string_literal: true

MochaTestType = GraphQL::ObjectType.define do
  name 'MochaTest'
  description 'Test details from Mocha'
  field :id, !types.Int
  field :title, !types.String
  field :fullTitle, !types.String, property: :full_title
  field :body, !types.String
  field :file, types.String
  field :duration, types.Int
  field :status, !types.String
  field :speed, types.String
  field :timedOut, types.Boolean, property: :timed_out
  field :pending, types.Boolean
  field :sync, types.Boolean
  field :async, types.Int
  field :currentRetry, types.Int, property: :current_retry
  field :err, types.String
end
