ReportType = GraphQL::ObjectType.define do
  name 'Report'
  description 'Reports of a Project'
  field :id, !types.ID
  field :project_id, !types.Int
  field :reportable_id, !types.Int
  field :reportable_type, !types.String
  field :status, !types.String do
    preload [{ reportable: [:summary] }]
    resolve -> (obj, args, ctx) { obj.reportable.status }
  end
  field :tags, !types[!types.String]
  field :created_at, !types.String
  field :updated_at, !types.String
end
