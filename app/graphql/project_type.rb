# frozen_string_literal: true

ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  field :id, !types.Int
  field :projectName, !types.String, property: :project_name
  field :reportsCount, !types.Int do
    resolve ->(obj, _args, _ctx) { obj.reports.count }
  end
  field :reports, !types[!ReportType] do
    description 'This project\'s reports'
    argument :lastDays, types.Int
    argument :lastMonths, types.Int

    preload :reports

    resolve lambda do |obj, args, _ctx|
      time_ago = args[:lastDays]&.days&.ago
      time_ago ||= args[:lastMonths]&.months&.ago
      return obj.cached_reports unless time_ago
      obj.reports.updated_since(time_ago)
    end
  end
  field :scenarios, !types[!ScenarioType] do
    description 'Test Scenarios executed for the Project'
    argument :lastDays, types.Int
    argument :lastMonths, types.Int

    resolve lambda do |obj, args, _context|
      time_ago = args[:lastDays]&.days&.ago
      time_ago ||= args[:lastMonths]&.months&.ago
      return obj.cached_scenarios unless time_ago
      obj.scenarios_from(time_ago)
    end
  end
  field :createdAt, !types.String, property: :created_at
  field :updatedAt, !types.String, property: :updated_at
end
