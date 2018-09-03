# frozen_string_literal: true

RspecExampleType = GraphQL::ObjectType.define do
  name 'RspecExample'
  description 'Test example from Rspec'
  field :id, !types.Int
  field :spec_id, !types.String
  field :description, !types.String
  field :full_description, !types.String
  field :exception, RspecExceptionType do
    description 'RspecReport Exception'\
                'Only available for failed examples'
    preload :exception
    resolve ->(obj, _args, _ctx) { obj.exception }
  end
  field :status, !types.String
  field :file_path, !types.String
  field :line_number, !types.Int
  field :run_time, !types.Float
  field :pending_message, types.String
end
