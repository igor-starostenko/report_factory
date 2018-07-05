RspecSummaryType = GraphQL::ObjectType.define do
  name 'RspecSummary'
  description 'Summary of an Rspec Report'
  field :id, !types.ID
  field :rspec_report_id, !types.Int
  field :duration, !types.Float
  field :example_count, !types.Int
  field :failure_count, !types.Int
  field :pending_count, !types.Int
  field :errors_outside_of_examples_count, !types.Int
end
