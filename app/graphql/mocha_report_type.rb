# frozen_string_literal: true

MochaReportType = GraphQL::ObjectType.define do
  name 'MochaReport'
  description 'Type of a Report'
  field :duration, types.Int
  field :id, !types.Int
  field :failures, types.Int
  field :passes, types.Int
  field :pending, types.Int
  field :report, ReportType do
    preload :report
    resolve ->(obj, _args, _ctx) { obj.report }
  end
  field :suites, types.Int
  field :status, !types.String do
    resolve ->(obj, _args, _ctx) { obj.status }
  end
  field :tests, types[MochaTestType] do
    description 'Mocha tests'
    preload :tests
    resolve ->(obj, _args, _ctx) { obj.tests }
  end
  field :total, types.Int
  field :started, types.String
  field :ended, types.String
end
