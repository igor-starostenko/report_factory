# frozen_string_literal: true

RspecReportType = GraphQL::ObjectType.define do
  name 'RspecReport'
  description 'Type of a Report'
  field :id, !types.Int
  field :version, !types.String

  field :examples, !types[!RspecExampleType] do
    description 'Rspec Examples'
    resolve ->(obj, _args, _ctx) { obj.examples }
  end

  field :summary, !RspecSummaryType do
    description 'RspecReport Summary'
    resolve ->(obj, _args, _ctx) { obj.summary }
  end

  field :summary_line, !types.String do
    resolve ->(obj, _args, _ctx) { obj&.summary_line || '' }
  end
end
