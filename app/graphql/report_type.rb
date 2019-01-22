# frozen_string_literal: true

ReportType = GraphQL::ObjectType.define do
  name 'Report'
  description 'Reports of a Project'
  field :id, !types.Int
  field :projectId, !types.String, property: :project_id
  field :projectName, !types.String do
    preload :project
    resolve ->(obj, _args, _ctx) { obj.project.project_name }
  end
  field :reportableId, !types.String, property: :reportable_id
  field :reportableType, !types.String do
    resolve ->(obj, _args, _ctx) { obj.reportable_type.gsub('Report', '') }
  end
  field :reportable, ReportableType do
    description 'This report\'s details based on type'
    preload :reportable
    resolve ->(obj, _args, _ctx) { obj.reportable }
  end
  field :status, !types.String
  field :tags, !types[!types.String]
  field :createdAt, !types.String, property: :created_at
  field :updatedAt, !types.String, property: :updated_at
end
