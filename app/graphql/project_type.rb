# frozen_string_literal: true

ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  field :id, !types.Int
  field :projectName, !types.String, property: :project_name
  field :reports, !types[!ReportType] do
    description 'This project\'s reports'
    preload :reports
    resolve ->(obj, _args, _ctx) { obj.cached_reports }
  end
  field :scenarios, !types[!ScenarioType] do
    description 'Test Scenarios executed for the Project'
    resolve ->(obj, _args, _context) { obj.cached_scenarios }
  end
  field :createdAt, !types.String, property: :created_at
  field :updatedAt, !types.String, property: :updated_at
end
