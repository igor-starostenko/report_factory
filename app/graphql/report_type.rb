ReportType = GraphQL::ObjectType.define do
  name 'Report'
  description 'Reports of a Project'
  field :id, !types.ID
  field :project_id, !types.String
  field :reportable_id, !types.String
  field :reportable_type, !types.String
  field :status, !types.String
  field :tags, !types[!types.String]
  field :created_at, !types.String
  field :updated_at, !types.String
end
