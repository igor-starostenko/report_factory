# frozen_string_literal: true

ScenarioType = GraphQL::ObjectType.define do
  name 'Scenario'
  description 'Test Scenario'
  field :projectName, !types.String do
    preload(report: :project)
    resolve ->(obj, _args, _ctx) { obj.report.project.project_name }
  end
  field :specId, !types.String do
    resolve ->(obj, _args, _ctx) { obj.spec_id }
  end
  field :description, !types.String do
    resolve ->(obj, _args, _ctx) { obj.description }
  end
  field :fullDescription, !types.String do
    resolve ->(obj, _args, _ctx) { obj.full_description }
  end
  field :status, !types.String do
    resolve ->(obj, _args, _ctx) { obj.status }
  end
  field :lineNumber, types.Int do
    resolve ->(obj, _args, _ctx) { obj.line_number }
  end
end
