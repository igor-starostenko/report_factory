# frozen_string_literal: true

RspecReportType = GraphQL::ObjectType.define do
  name 'RspecReport'
  description 'Type of a Report'
  field :id, !types.Int
  field :version, !types.String
  field :report, ReportType do
    preload :report
    resolve ->(obj, _args, _ctx) { obj.report }
  end
  field :examples, types[RspecExampleType] do
    description 'Rspec Examples'
    preload :examples
    resolve ->(obj, _args, _ctx) { obj.examples }
  end
  field :summary, RspecSummaryType do
    description 'RspecReport Summary'
    preload :summary
    resolve ->(obj, _args, _ctx) { obj.summary }
  end
  field :summaryLine, types.String, property: :summary_line
end
