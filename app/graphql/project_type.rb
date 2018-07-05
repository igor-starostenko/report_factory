ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  field :id, !types.ID
  field :project_name, !types.String
  field :created_at, !types.String
  field :updated_at, !types.String
  field :reports, !types[!ReportType] do
    description 'This project\'s reports,'\
                ' or null if this project has no reports'
    preload :reports
    resolve -> (obj, args, ctx) { obj.reports }
  end
end
