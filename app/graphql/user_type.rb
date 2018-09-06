# frozen_string_literal: true

UserType = GraphQL::ObjectType.define do
  name 'User'
  field :id, !types.Int
  field :name, !types.String
  field :type, !types.String
  field :email, !types.String
  field :reports, !types[!ReportType] do
    description 'This user\'s reports'
    resolve ->(obj, _args, _ctx) { obj.cached_reports }
  end
  field :createdAt, !types.String, property: :created_at
  field :updatedAt, !types.String, property: :updated_at
end
