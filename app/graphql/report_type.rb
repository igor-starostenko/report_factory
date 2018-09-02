# frozen_string_literal: true

ReportType = GraphQL::ObjectType.define do
  name 'Report'
  description 'Reports of a Project'
  field :id, !types.Int
  field :project_id, !types.String
  field :project_name, !types.String do
    preload :project
    resolve ->(obj, _args, _ctx) { obj.project.project_name }
  end
  field :reportable_id, !types.String
  field :reportable_type, !types.String
  field :reportable, !RspecReportType do
    description 'This report\'s details based on type'
    preload :reportable
    resolve ->(obj, _args, _ctx) { obj.reportable }
  end
  field :status, !types.String
  field :tags, !types[!types.String]
  field :created_at, !types.String
  field :updated_at, !types.String
end
