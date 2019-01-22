# frozen_string_literal: true

ReportableType = GraphQL::UnionType.define do
  name 'Reportable'
  description 'Objects which can be reported'
  possible_types [RspecReportType, MochaReportType]
end
