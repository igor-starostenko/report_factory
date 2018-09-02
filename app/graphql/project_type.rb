# frozen_string_literal: true

ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  field :id, !types.Int
  field :project_name, !types.String
  field :created_at, !types.String
  field :updated_at, !types.String
  field :reports, !types[!ReportType] do
    description 'This project\'s reports,'\
                ' or null if this project has no reports'
    preload :reports
    resolve ->(obj, _args, _ctx) { obj.cached_reports }
  end
  field :scenarios, !types[!ScenarioType] do
    description 'Test Scenarios executed for the Project'
    resolve ->(obj, _args, _context) { obj.cached_scenarios }
  end
end
