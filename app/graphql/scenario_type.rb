# frozen_string_literal: true

ScenarioType = GraphQL::ObjectType.define do
  name 'Scenario'
  description 'Test Scenario'
  field :project_name, !types.String do
    preload(report: :project)
    resolve ->(obj, _args, _ctx) { obj.report.project.project_name }
  end
  field :spec_id, !types.String do
    resolve ->(obj, _args, _ctx) { obj.spec_id }
  end
  field :description, !types.String do
    resolve ->(obj, _args, _ctx) { obj.description }
  end
  field :full_description, !types.String do
    resolve ->(obj, _args, _ctx) { obj.full_description }
  end
  field :status, !types.String do
    resolve ->(obj, _args, _ctx) { obj.status }
  end
  field :line_number, !types.Int do
    resolve ->(obj, _args, _ctx) { obj.line_number }
  end
end
