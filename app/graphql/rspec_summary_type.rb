# frozen_string_literal: true

RspecSummaryType = GraphQL::ObjectType.define do
  name 'RspecSummary'
  description 'Summary of an RspecReport'
  field :id, !types.Int
  field :rspecReportId, !types.Int, property: :rspec_report_id
  field :duration, !types.Float
  field :exampleCount, !types.Int, property: :example_count
  field :failureCount, !types.Int, property: :failure_count
  field :pendingCount, !types.Int, property: :pending_count
  field :errorsOutsideOfExamplesCount, !types.Int,
        property: :errors_outside_of_examples_count
end
