# frozen_string_literal: true

# Formats Rspec Reports JSON API
class SerializableRspecReport < JSONAPI::Serializable::Resource
  type 'rspec_report'

  attributes :id
  attribute :project_name { @object.project.project_name }
  attribute :project_id { @object.project.id }
  attribute :report_id { @object.report.id }
  attribute :report_type { 'RSpec' }
  attribute :date do
    {
      created_at: @object.report.created_at,
      updated_at: @object.report.updated_at
    }
  end
end
