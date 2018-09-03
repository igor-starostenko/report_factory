# frozen_string_literal: true

RspecExampleType = GraphQL::ObjectType.define do
  name 'RspecExample'
  description 'Test example from Rspec'
  field :id, !types.Int
  field :specId, !types.String, property: :spec_id
  field :description, !types.String
  field :fullDescription, !types.String, property: :full_description
  field :exception, RspecExceptionType do
    description 'RspecReport Exception'\
                'Only available for failed examples'
    preload :exception
    resolve ->(obj, _args, _ctx) { obj.exception }
  end
  field :status, !types.String
  field :filePath, !types.String, property: :filePath
  field :lineNumber, !types.Int, property: :line_number
  field :runTime, !types.Float, property: :run_time
  field :pendingMessage, types.String, property: :pending_message
end
