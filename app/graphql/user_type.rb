# frozen_string_literal: true

UserType = GraphQL::ObjectType.define do
  name 'User'
  field :id, !types.Int
  field :name, !types.String
  field :type, !types.String
  field :email, !types.String
  field :reportsCount, !types.Int do
    resolve ->(obj, _args, _ctx) { obj.reports.count }
  end
  field :reports, !types[!ReportType] do
    description 'This user\'s reports'
    argument :lastDays, types.Int
    argument :lastMonths, types.Int

    preload :reports

    resolve lambda { |obj, args, _ctx|
      time_ago = args[:lastDays]&.days&.ago
      time_ago ||= args[:lastMonths]&.months&.ago
      return obj.cached_reports unless time_ago

      obj.reports.updated_since(time_ago)
    }
  end
  field :createdAt, !types.String, property: :created_at
  field :updatedAt, !types.String, property: :updated_at
end
