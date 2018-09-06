# frozen_string_literal: true

RspecExceptionType = GraphQL::ObjectType.define do
  name 'RspecException'
  description 'Exception of an Example'
  field :id, !types.Int
  field :classname, !types.String
  field :message, !types.String
  field :backtrace, !types[!types.String]
end
